import boto3

def confirm_user_signup(username, confirmation_code):
    session = boto3.Session(profile_name='personal', region_name='us-east-1')
# Create a Cognito client
    client = session.client('cognito-idp')

    try:
        response = client.confirm_sign_up(
            ClientId='2sch552trs09sjou2c5pj9hb1o',
            Username=username,
            ConfirmationCode=confirmation_code
        )
        print("User confirmed successfully!")
    except client.exceptions.CodeMismatchException as e:
        print("Invalid confirmation code:", e)
    except client.exceptions.UserNotFoundException as e:
        print("User not found:", e)
    except client.exceptions.NotAuthorizedException as e:
        print("User is already confirmed:", e)
    except Exception as e:
        print("An error occurred:", e)

# Example usage:
# username = 'user@example.com'  # Replace with the user's username or email
# confirmation_code = '123456'  # Replace with the confirmation code the user received

confirm_user_signup("uzairy2@gmail.com", "144232")