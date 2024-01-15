# API CONFIRM USER

## Description

This is an api to confirm a user in a cognito user pool

## Base URL

The base URL for all API requests is:

`https://tv7vhfyv8g.execute-api.us-east-1.amazonaws.com/Stage`

## Endpoints

### `POST /confirm`

Returns a message regarding the success of confirming user.

### Request Body

- `username` (required): The new users email address.
- `confirmation_code` (required): The confirmation code sent via email to the user.

### Response

Returns a JSON object with the following properties:

- `message`: A message regarding the success of adding a user.

### Example

Request:

```
POST /confirm
```

Response:

```json
{
    "message": "User confirmed successfully!",
}

```

## Errors

This API uses the following error codes:

- `400 Code Mismatch`: The confirmation code is invalid.
- `400 Not Authorized`: User already exists.
- `404 Not Found`: User is not found.
- `500 Internal Server Error`: An unexpected error occurred on the server.