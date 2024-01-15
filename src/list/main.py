import boto3
import json
import os

client = boto3.client('s3')



def lambda_handler(event, context):

    try:
        sub = event['requestContext']["authorizer"]['claims']['sub']
        print(sub)
        bucket_name = "csv-mweb"
        folder = sub
        response = client.list_objects_v2(Bucket=bucket_name, Prefix=folder)
        csv_files=[]
        # Print CSV files in the specified folder
        for obj in response.get('Contents', []):
            key = obj['Key']
            if key.endswith('.csv'):
                filename = os.path.basename(key)
                csv_files.append(filename)
                print(f"CSV File: {filename}")

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps({'files': csv_files})
        }
    except client.exceptions.NotAuthorizedException as e:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Invalid credentials'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)})
        }