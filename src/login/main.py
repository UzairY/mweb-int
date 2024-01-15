import boto3
import json
import os

client = boto3.client('cognito-idp')

COGNITOCLIENT = os.environ["COGNITOCLIENT"]

def lambda_handler(event, context):
    # username = event['body']['username']
    # password = event['body']['password']
    if isinstance(event['body'], str):
        body_dict = json.loads(event['body'])
        username = body_dict.get('username')
        password = body_dict.get('password')
        # Use the values retrieved from the parsed JSON
    else:
        # 'body' is already a dictionary
        username = event['body'].get('username')
        password = event['body'].get('password')

    try:
        response = client.initiate_auth(
            ClientId=COGNITOCLIENT,
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': username,
                'PASSWORD': password
            }
        )
        token=response['AuthenticationResult']['IdToken']
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps({'token': token})
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