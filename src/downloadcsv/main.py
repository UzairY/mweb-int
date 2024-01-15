import boto3
import json



def lambda_handler(event, context):
    client = boto3.client('s3')

    if isinstance(event['body'], str):
        body_dict = json.loads(event['body'])
        filename = body_dict.get('filename')
        # Use the values retrieved from the parsed JSON
    else:
        # 'body' is already a dictionary
        filename = event['body'].get('filename')

    sub = event['requestContext']["authorizer"]['claims']['sub']
    bucket_name = "csv-mweb"
    key = sub+"/"+filename

    try:
        # Download the CSV file from S3
        response = client.generate_presigned_url(
            "get_object",
            Params={
                "Bucket":bucket_name,
                "Key":key
            },
            ExpiresIn=600
            )

        # Return the encoded content as the API Gateway response
        return {
            'statusCode': 200,
            'headers': {
            },
            'body': json.dumps({'Pre-Signed URL': response})
        }

    except client.exceptions.NotAuthorizedException as e:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Invalid credentials'})
        }

    except Exception as e:
        # Handle any exceptions that might occur during the download
        return {
            'statusCode': 500,
            'body': f'Error downloading CSV file: {str(e)}'
        }


