import json

def lambda_handler(event, context):
    print("Hello from Terraform!")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Serverless Land!')
    }