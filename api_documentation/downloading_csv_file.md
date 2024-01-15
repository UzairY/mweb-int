# API DOWNLOAD CSV FILE

## Description

This is an api to download a specific csv file from a user's folder.

## Base URL

The base URL for all API requests is:

`https://tv7vhfyv8g.execute-api.us-east-1.amazonaws.com/Stage`

## Endpoints

### `POST /downcsv`

Returns a pre signed url link to download a file from s3.

### Headers

- `Authorization` (required): Bearer {token}

### Request Body

- `filename` (required): name of the csv file


### Response

Returns a JSON object with the following properties:

- `Pre-Signed URL`: https: //bucket.s3.amazonaws.com/

### Example

Request:

```
POST /downcsv
```

Response:

```json
{
    "Pre-Signed URL": "https://bucket.s3.amazonaws.com/"
}

```

## Errors

This API uses the following error codes:

- `401 Invalid credendtials`: The bearer token used is invalid.
- `500 Internal Server Error`: An unexpected error occurred on the server.