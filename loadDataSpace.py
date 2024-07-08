import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.sql import functions as F

# READ PARAMETERS
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

# START JOB CONTEXT AND JOB
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# FROM FILES
tedx_dataset_path = "s3://tspacedx-bucket-data/final_list.csv"
details_dataset_path = "s3://tspacedx-bucket-data/details.csv"
images_dataset_path = "s3://tspacedx-bucket-data/images.csv"
tags_dataset_path = "s3://tspacedx-bucket-data/tags.csv"

# READ TEDX DATASET
tedx_dataset = spark.read \
    .option("header", "true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(tedx_dataset_path)

# FILTER NULL POSTING KEY
count_items = tedx_dataset.count()
count_items_null = tedx_dataset.filter("id is not null").count()

print(f"Number of items from RAW DATA {count_items}")
print(f"Number of items from RAW DATA with NOT NULL KEY {count_items_null}")

# READ DETAILS DATASET
details_dataset = spark.read \
    .option("header", "true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(details_dataset_path) \
    .select(F.col("id").alias("id_ref"),
            F.col("description"),
            F.col("duration"),
            F.col("publishedAt"))

# JOIN WITH TEDX DATASET
tedx_dataset_main = tedx_dataset.join(details_dataset, tedx_dataset.id == details_dataset.id_ref, "left") \
    .drop("id_ref")

# READ IMAGES DATASET
images_dataset = spark.read \
    .option("header", "true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(images_dataset_path) \
    .select(F.col("id").alias("id_ref"),
            F.col("url").alias("image_url"))

# JOIN WITH TEDX DATASET
tedx_dataset_main = tedx_dataset_main.join(images_dataset, tedx_dataset_main.id == images_dataset.id_ref, "left") \
    .drop("id_ref")

# READ TAGS DATASET AND FILTER FOR "space"
tags_dataset = spark.read.option("header", "true").csv(tags_dataset_path)
tags_dataset_filtered = tags_dataset.filter(F.col("tag") == "space")

# AGGREGATE MODEL, ADD TAGS TO TEDX_DATASET
tags_dataset_agg = tags_dataset_filtered.groupBy(F.col("id").alias("id_ref")).agg(F.collect_list("tag").alias("tags"))

# JOIN TAGS WITH TEDX DATASET
tedx_dataset_agg = tedx_dataset_main.join(tags_dataset_agg, tedx_dataset_main.id == tags_dataset_agg.id_ref, "left") \
    .drop("id_ref") \
    .select(F.col("id").alias("_id"),
            F.col("slug"),
            F.col("speakers"),
            F.col("title"),
            F.col("url"),
            F.col("description"),
            F.col("duration"),
            F.col("publishedAt"),
            F.col("image_url"),
            F.col("tags"))

# AGGREGATE ALL TAGS FOR EACH ITEM
all_tags_dataset = tags_dataset.groupBy(F.col("id").alias("id_ref")).agg(F.collect_list("tag").alias("all_tags"))

# JOIN ALL TAGS WITH TEDX DATASET
tedx_dataset_agg_final = tedx_dataset_agg.join(all_tags_dataset, tedx_dataset_agg._id == all_tags_dataset.id_ref, "left") \
    .drop("id_ref") \
    .select(F.col("_id"),
            F.col("slug"),
            F.col("speakers"),
            F.col("title"),
            F.col("url"),
            F.col("description"),
            F.col("duration"),
            F.col("publishedAt"),
            F.col("image_url"),
            F.col("all_tags").alias("tags"))

# FILTER DOCUMENTS THAT DO NOT CONTAIN "space" IN TAGS
tedx_dataset_agg_final_with_space_tags = tedx_dataset_agg_final.filter(F.array_contains(F.col("tags"), "space"))

# PRINT SCHEMA
tedx_dataset_agg_final_with_space_tags.printSchema()

# WRITE TO MONGODB
write_mongo_options = {
    "connectionName": "TEDX2024",
    "database": "tspacedx",
    "collection": "tspacedx_data",
    "ssl": "true",
    "ssl.domain_match": "false"
}

from awsglue.dynamicframe import DynamicFrame

tedx_dataset_dynamic_frame = DynamicFrame.fromDF(tedx_dataset_agg_final_with_space_tags, glueContext, "nested")

glueContext.write_dynamic_frame.from_options(tedx_dataset_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)
