import json
from hailstone_py.hailstone import calculate_hailstone, finalize_sequence

def lambda_handler(event, context):
    try:
        qs = event.get("queryStringParameters") or {}
        start = int(qs.get("start", 1))
        sequence = calculate_hailstone(start)
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "start": start,
                "steps": len(sequence) - 1,
                "sequence": sequence,
                "summary": finalize_sequence(sequence)
            })
        }
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)})
        }
