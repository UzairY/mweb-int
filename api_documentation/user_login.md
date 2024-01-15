# API USER LOGIN

## Description

This is an api for a user to login

## Base URL

The base URL for all API requests is:

`https://tv7vhfyv8g.execute-api.us-east-1.amazonaws.com/Stage`

## Endpoints

### `POST /login`

Returns a parameters regarding the success of a user logging in.

### Request Body

- `username` (required): The user's email address.
- `password` (required): The password for the user.

### Response

Returns a JSON object with the following properties:

- `token`: A temporary Authorization token for a user.

### Example

Request:

```
POST /login
```

Response:

```json
{
    "token": "eyJraWQiOiJEWjFsQ1V4VHBXRTlpNkxFVmFoWlMrOEFzUGZmbnNPT0lxNzBob3pwVTFBPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiI5ODBiMjkyMi0xM2IyLTQ3YzAtODg1Ny04Njk1Zjc1Y2IxYjUiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfSVB5a2F0VFYxIiwiY29nbml0bzp1c2VybmFtZSI6InV6YWlyeTJAZ21haWwuY29tIiwib3JpZ2luX2p0aSI6ImRhYjY1ODhmLWFiMGUtNDU0My1hYTdmLTI2YjU3MTJhODg4MCIsImF1ZCI6IjJzY2g1NTJ0cnMwOXNqb3UyYzVwajloYjFvIiwiZXZlbnRfaWQiOiIwZGIyYzJkYy1iNDI4LTQyYzktOGVkMS1iZTM5NmM5M2JjODQiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTcwNTMwOTk0NCwiZXhwIjoxNzA1MzEzNTQ0LCJpYXQiOjE3MDUzMDk5NDQsImp0aSI6Ijc5MmE5OTQ5LWM0N2UtNDM2My04ZGQ5LWFhYTNjMzQ4Zjg3MCIsImVtYWlsIjoidXphaXJ5MkBnbWFpbC5jb20ifQ.ifPBUKk7LijauDZhltMBmSRmSXlEwHFHwhi9_Z7TFuVKLBJ6PWCm-FwVX-Yi0vqeftL10KtwI0zeTufAfi2nii4T1xdXCdLf7XWylM4Jk7ag4OcxKCs4dLmhsbafxmcdjYmeGfIGvxYag3H4FxABfcPmJWwq2rbWn3ziIAuQtTucj9zNLM5zSOlrO9Jg4gzDfBnpO-PvNmDII01IbGAHaDgXdTaR23kMRIdKVfYpd7zHukbw6n81fGGyvBIEHNOFeAYXKXj7h7A0xNXJBia7n1H_WcM1gtgD0x-so6ARGjbvSEOZG7cfWLqaCGW49hjgLu1nCqD-kbuMpgBHUG15Bw",
}

```

## Errors

This API uses the following error codes:

- `401 Invalid`: The credentials used to log in are invalid.
- `500 Internal Server Error`: An unexpected error occurred on the server.