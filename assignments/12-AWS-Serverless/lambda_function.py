# lambda_function.py

def lambda_handler(event, context):
    """
    AWS Lambda entry point.

    Args:
        event (dict): Contains data regarding the event that triggered the function
                      (e.g., HTTP request details from API Gateway).
        context (object): Provides runtime information (e.g., function name, memory limit).

    Returns:
        dict: A response object compatible with API Gateway Proxy Integration.
    """
    return {
        'statusCode': 200,
        'body': 'Hello, World!'
    }