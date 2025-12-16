import json
import boto3



def lambda_handler(event, context):
    secret_name = "myDBCredentials"
    region_name = "us-east-1"


    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:

        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
        secret = get_secret_value_response['SecretString']


        print("Success! Secret retrieved.")


        return {
            'statusCode': 200,
            'body': json.dumps('Secret retrieved successfully!')
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Failed to retrieve secret')
        }