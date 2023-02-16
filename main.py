import json


def lambda_handler(event, context):
    try:
        print("Hello from Lambda 2!")
    except Exception as e:
        print(e)

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda 2!')
    }
