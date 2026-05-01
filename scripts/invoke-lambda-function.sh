#!/bin/bash

FUNCTION_NAME=$1

aws lambda invoke \
    --function-name "$FUNCTION_NAME" \
    --region ap-south-1 \
    response.json

echo "Invoked Lambda: $FUNCTION_NAME"