import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.sql import functions as F
from awsglue.dynamicframe import DynamicFrame

# LEGGE I PARAMETRI
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

# INIZIALIZZA IL CONTESTO DEL JOB E IL JOB
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Definisce le opzioni di connessione MongoDB utilizzando la connessione esistente
read_mongo_options = {
    "connectionName": "TEDX2024",
    "database": "tspacedx",
    "collection": "tspacedx_data",
    "ssl": "true",
    "ssl.domain_match": "false"
}

# Carica i dati da MongoDB in un DynamicFrame
tedx_dynamic_frame = glueContext.create_dynamic_frame.from_options(
    connection_type="mongodb",
    connection_options=read_mongo_options
)

# Converte DynamicFrame in DataFrame
tedx_df = tedx_dynamic_frame.toDF()

# Estrae i tag e aggiungili come una nuova colonna
tedx_df = tedx_df.withColumn("tags", F.col("tags"))

# Definisce una lista di tuple tag-valore per accumulare il conteggio
tag_value_mapping = [
    ("space", 10),
    ("astronomy", 7),
    ("Planets", 7),
    ("aliens", 5),
    ("science", 5),
    ("technology", 5),
    ("future", 7)
]

# Calcola next_video_count basato sui tag
tedx_df = tedx_df.withColumn("next_video_count",
    sum([F.when(F.array_contains("tags", tag), value).otherwise(0) for tag, value in tag_value_mapping])
)

# Seleziona solo le colonne necessarie per achievement_df
achievement_df = tedx_df.select("_id", "next_video_count") \
    .withColumn("achievement", F.lit("Watched and moved to another video")) \
    .withColumn("date", F.current_timestamp())

# Definisce le opzioni di scrittura MongoDB per la collezione achievements
write_mongo_options = {
    "connectionName": "TEDX2024",
    "database": "tspacedx",
    "collection": "tspacedx_achievement",
    "ssl": "true",
    "ssl.domain_match": "false"
}

# Converte DataFrame in DynamicFrame per scrivere su MongoDB
achievement_dynamic_frame = DynamicFrame.fromDF(achievement_df, glueContext, "achievement_dynamic_frame")

# Scrive il DynamicFrame su MongoDB
glueContext.write_dynamic_frame.from_options(
    frame=achievement_dynamic_frame, 
    connection_type="mongodb", 
    connection_options=write_mongo_options
)

# TERMINA IL JOB
job.commit()
