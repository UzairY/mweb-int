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
        confirmation_code = body_dict.get('confirmation_code')
        # Use the values retrieved from the parsed JSON
    else:
        # 'body' is already a dictionary
        username = event['body'].get('username')
        confirmation_code = event['body'].get('confirmation_code')

    try:
        response = client.confirm_sign_up(
            ClientId=COGNITOCLIENT,
            Username=username,
            ConfirmationCode=confirmation_code
        )
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "User confirmed successfully!"})
        }
    except client.exceptions.CodeMismatchException as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": str(e)})
        }
    except client.exceptions.UserNotFoundException as e:
        return {
            "statusCode": 404,
            "body": json.dumps({"message": str(e)})
        }
    except client.exceptions.NotAuthorizedException as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": str(e)})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": str(e)})
        }
