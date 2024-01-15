# API ADD CSV FILE

## Description

This is an api to add a csv files in the user specific folder.

## Base URL

The base URL for all API requests is:

`https://tv7vhfyv8g.execute-api.us-east-1.amazonaws.com/Stage`

## Endpoints

### `POST /addcsv`

Returns a message regarding the success of adding a file to s3.

### Headers

- `Authorization` (required): Bearer {token}

### Request Body (form-data)

- `Key` (required): {file}


### Response

Returns a JSON object with the following properties:

- `message`: File added successfully.

### Example

Request:

```
POST /addcsv
```

Response:

```json
{
    "message": "File added successfully"
}

```

## Errors

This API uses the following error codes:

- `401 Invalid credendtials`: The bearer token used is invalid.
- `500 Internal Server Error`: An unexpected error occurred on the server.