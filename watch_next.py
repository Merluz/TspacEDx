import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.sql import functions as F
from pyspark.sql.window import Window
from awsglue.dynamicframe import DynamicFrame

# LEGGE I PARAMETRI
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

# INIZIALIZZA IL JOB CONTEXT E IL JOB
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# OPZIONI DI CONNESSIONE MONGODB PER LA LETTURA
read_mongo_options = {
    "connectionName": "TEDX2024",
    "database": "tspacedx",
    "collection": "tspacedx_data",
    "ssl": "true",
    "ssl.domain_match": "false"
}

# LEGGE I DATI DA MONGODB
tedx_dataset = glueContext.create_dynamic_frame.from_options(
    connection_type="mongodb",
    connection_options=read_mongo_options
).toDF()

# FUNZIONE PER TROVARE VIDEO CON TAG SIMILI
def find_similar_videos(df):
    exploded_df = df.withColumn("tag", F.explode("tags"))
    
    # Self-join per trovare tutti i video con almeno un tag in comune diverso da se stessi
    joined_df = exploded_df.alias("df1").join(
        exploded_df.alias("df2"),
        (F.col("df1.tag") == F.col("df2.tag")) & (F.col("df1._id") != F.col("df2._id")),
        "inner"
    ).select(
        F.col("df1._id").alias("current_id"),
        F.col("df2._id").alias("next_id")
    ).distinct()
    
    return joined_df

# TROVA I VIDEO SIMILI
similar_videos_df = find_similar_videos(tedx_dataset)

# Recupera i dati next_video_count da tspacedx_achievement
achievement_options = {
    "connectionName": "TEDX2024",
    "database": "tspacedx",
    "collection": "tspacedx_achievement",
    "ssl": "true",
    "ssl.domain_match": "false"
}

achievement_df = glueContext.create_dynamic_frame.from_options(
    connection_type="mongodb",
    connection_options=achievement_options
).toDF()

# Unisce similar_videos_df con achievement_df per ottenere next_video_count
joined_df = similar_videos_df.join(
    achievement_df,
    similar_videos_df["next_id"] == achievement_df["_id"],
    "left"
).select(
    similar_videos_df["current_id"],
    similar_videos_df["next_id"],
    achievement_df["next_video_count"]
)

# Determina il next_id con la priorità più alta per ogni current_id basato su next_video_count
window_spec = Window.partitionBy("current_id").orderBy(F.desc("next_video_count"))
prioritized_df = joined_df.withColumn("rank", F.row_number().over(window_spec)).where(F.col("rank") == 1).drop("rank")

# Scrive prioritized_df nella collezione MongoDB watch_next_data
write_mongo_options = {
    "connectionName": "TEDX2024",
    "database": "tspacedx",
    "collection": "watch_next_data",
    "ssl": "true",
    "ssl.domain_match": "false"
}

prioritized_dynamic_frame = DynamicFrame.fromDF(prioritized_df, glueContext, "nested")

glueContext.write_dynamic_frame.from_options(
    frame=prioritized_dynamic_frame,
    connection_type="mongodb",
    connection_options=write_mongo_options
)

# TERMINA IL JOB
job.commit()
