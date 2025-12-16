import json
import boto3


def lambda_handler(event, context):
    """
    Retrieves a secret from AWS Secrets Manager and returns it via the API.
    """
    secret_name = "MyTask5Secret"
    region_name = "us-east-1"

    # Create a Secrets Manager client
    client = boto3.client('secretsmanager', region_name=region_name)

    try:
        # Attempt to retrieve the secret value
        response = client.get_secret_value(SecretId=secret_name)

        # Check if the secret string is present and return it
        if 'SecretString' in response:
            secret = response['SecretString']
            return {
                'statusCode': 200,
                'body': json.dumps(f"SUCCESS! The secret password is: {secret}")
            }

    except Exception as e:
        # Handle errors and return a 500 status code
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error retrieving secret: {str(e)}")
        }