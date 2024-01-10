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
        response = client.sign_up(
            ClientId=COGNITOCLIENT,
            Username=username,
            Password=password,
            UserAttributes=[
                {'Name': 'email', 'Value': username},
                # Add more attributes if needed
            ]
        )
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }
    except client.exceptions.UsernameExistsException as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Username already exists'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)})
        }