import boto3
import json
import os
import base64
import re

def s3_filename_check(filename):
    # Check for valid characters
    valid_characters_pattern = re.compile(r'[a-zA-Z0-9_\-\.\/]+$')
    if not valid_characters_pattern.match(filename):
        return False

    # Check length limit
    if len(filename) > 1024:
        return False

    return True

client = boto3.client('s3')

def lambda_handler(event, context):

    try:
        sub = event['requestContext']["authorizer"]['claims']['sub']
        print(sub)
        bucket_name = "csv-mweb"
        folder = sub

        match = re.search(r'filename="(.+?)"', event['body'], re.DOTALL)
        if match:
            original_filename = match.group(1)

        if not s3_filename_check(original_filename):
            raise Exception('Invalid filename. Please use only valid characters and ensure the filename length is within the limit.')



        content_match = re.search(r'\r\n\r\n([\s\S]+?)\r\n\r\n', event['body'], re.DOTALL)
        if content_match:
            file_content = content_match.group(1)
        
        csv_content = file_content.encode()

        key = folder+"/"+original_filename

        # Get CSV file content from the request
        # csv_content = base64.b64decode(event['body'])

        response = client.put_object(Body=csv_content, Bucket=bucket_name, Key=key)



        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps({'message': 'File added successfully'})
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