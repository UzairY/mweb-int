# API SIGNUP

## Description

This is an api to register a new user in a cognito user pool

## Base URL

The base URL for all API requests is:

`https://tv7vhfyv8g.execute-api.us-east-1.amazonaws.com/Stage`

## Endpoints

### `POST /signup`

Returns a message regarding the success of registering an unconfirmed user.

### Request Body

- `username` (required): The new users email address.
- `password` (required): The password for the user.

### Response

Returns a JSON object with the following properties:

- `message`: A message regarding the success of adding a user.

### Example

Request:

```
POST /signup
```

Response:

```json
{
    "message": "New user is added successfully",
}

```

## Errors

This API uses the following error codes:

- `400 Bad Request`: The user already exists.
- `500 Internal Server Error`: An unexpected error occurred on the server.