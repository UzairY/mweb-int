import boto3
import json
import os

client = boto3.client('s3')



def lambda_handler(event, context):

    try:
        if isinstance(event['body'], str):
            body_dict = json.loads(event['body'])
            sql = body_dict.get('sql')
            filename = body_dict.get('filename')
        # Use the values retrieved from the parsed JSON
        else:
            # 'body' is already a dictionary
            sql = event['body'].get('sql')
            filename = event['body'].get('filename')

        sub = event['requestContext']["authorizer"]['claims']['sub']
        bucket_name = "csv-mweb"
        key = sub+"/"+filename

       # Specify the SQL expression for S3 Select
        # sql_expression = "SELECT * FROM s3object s WHERE s.\"Founded\" = '2009'" 
        sql_expression = sql

        # Set the S3 Select parameters
        select_params = {
            'ExpressionType': 'SQL',
            'Expression': sql_expression,
            'InputSerialization': {
                'CSV': {
                    'FileHeaderInfo': 'USE',
                    'RecordDelimiter': '\n',
                    'FieldDelimiter': ','
                }
            },
            'OutputSerialization': {
                'JSON': {
                    'RecordDelimiter': '\n'
                }
            }
        }

        # Perform S3 Select operation
        response = client.select_object_content(
            Bucket=bucket_name,
            Key=key,
            ExpressionType='SQL',
            Expression=sql_expression,
            InputSerialization={
                'CSV': {
                    'FileHeaderInfo': 'USE',
                    'RecordDelimiter': '\n',
                    'FieldDelimiter': ','
                }
            },
            OutputSerialization={
                'JSON': {
                    'RecordDelimiter': '\n'
                }
            }
        )

        # Process the S3 Select response
        for note in response['Payload']:
            if 'Records' in note:
                # Process records
                records = note['Records']['Payload'].decode('utf-8')
                print(records)
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps(records)
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