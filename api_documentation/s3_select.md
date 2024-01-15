# API S3 SELECT FROM CSV FILE

## Description

This is an api to use the s3 select feature on a csv file.

## Base URL

The base URL for all API requests is:

`https://tv7vhfyv8g.execute-api.us-east-1.amazonaws.com/Stage`

## Endpoints

### `POST /select`

Returns the result from an s3 select operation.

### Headers

- `Authorization` (required): Bearer {token}

### Request Body

- `sql` (required): The required sql statement
- `filename` (required): The filename to run the query against


### Response

Returns a JSON object with the following properties:

- `Response`: The result of the query

### Example

Request:

```
POST /select
```

Response:

```json
{
    {query results}
}

```

## Errors

This API uses the following error codes:

- `401 Invalid credendtials`: The bearer token used is invalid.
- `500 Internal Server Error`: An unexpected error occurred on the server.