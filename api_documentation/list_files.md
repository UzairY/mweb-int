# API LIST USERS FILES

## Description

This is an api to list the csv files in the user specific folder.

## Base URL

The base URL for all API requests is:

`https://tv7vhfyv8g.execute-api.us-east-1.amazonaws.com/Stage`

## Endpoints

### `GET /list`

Returns a message regarding the success of confirming user.

### Headers

- `Authorization` (required): Bearer {token}


### Response

Returns a JSON object with the following properties:

- `files`: List containing files in the user folder.

### Example

Request:

```
GET /list
```

Response:

```json
{
    "files": [
        "example1.csv",
        "example2.csv"
    ]
}

```

## Errors

This API uses the following error codes:

- `401 Invalid credendtials`: The bearer token used is invalid.
- `500 Internal Server Error`: An unexpected error occurred on the server.