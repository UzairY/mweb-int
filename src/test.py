import boto3
import os
import re
import base64

def s3_filename_check(filename):
    # Check for valid characters
    valid_characters_pattern = re.compile(r'[a-zA-Z0-9_\-\.\/]+$')
    if not valid_characters_pattern.match(filename):
        return False

    # Check length limit
    if len(filename) > 1024:
        return False

    return True

def confirm_user_signup():
    session = boto3.Session(profile_name='personal', region_name='us-east-1')
# Create a Cognito client
    client = session.client('s3')
    bucket_name = "csv-mweb"
    folder = "980b2922-13b2-47c0-8857-8695f75cb1b5"
    key=folder+"/example.csv"

    try:

        response = client.get_object(Bucket=bucket_name, Key=key)
        csv_content = response['Body'].read().decode('utf-8')

        # Encode the CSV content in base64
        encoded_content = base64.b64encode(csv_content.encode('utf-8')).decode('utf-8')
        print(csv_content)


    except client.exceptions.CodeMismatchException as e:
        print("Invalid confirmation code:", e)
    except client.exceptions.UserNotFoundException as e:
        print("User not found:", e)
    except client.exceptions.NotAuthorizedException as e:
        print("User is already confirmed:", e)
    except Exception as e:
        print("An error occurred:", e)


confirm_user_signup()