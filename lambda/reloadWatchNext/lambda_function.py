# Set up logging
import json
import os
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Import Boto 3 for AWS Glue
client = boto3.client('glue')

# Variables for the job:
glueJobName = "watch_next"

# Define Lambda function
def lambda_handler(event, context):
    try:
        response = client.start_job_run(JobName=glueJobName)
        logger.info('## STARTED GLUE JOB: ' + glueJobName)
        logger.info('## GLUE JOB RUN ID: ' + response['JobRunId'])
        
        # Aggiungi le intestazioni CORS
        headers = {
            'Access-Control-Allow-Origin': '*',  # Permette l'accesso da qualsiasi origine
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET',  # Metodi consentiti
            'Access-Control-Allow-Headers': 'Content-Type',  # Header consentiti
        }
        
        return {
            'statusCode': 200,
            'headers': headers,  # Includi le intestazioni CORS nella risposta
            'body': json.dumps('Glue job started successfully')
        }
    except Exception as e:
        logger.error(f'## Failed to start Glue job: {glueJobName}. Error: {str(e)}')
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',  # Permette l'accesso da qualsiasi origine
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET',  # Metodi consentiti
                'Access-Control-Allow-Headers': 'Content-Type',  # Header consentiti
            },
            'body': json.dumps(f'Failed to start Glue job: {glueJobName}. Error: {str(e)}')
        }
