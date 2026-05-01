aws rekognition detect-labels \
--image '{"S3Object":{"Bucket":"test-ai-ml-bucket-april26","Name":"public-place.jfif"}}' \
--max-labels 10 \
--region us-east-1 \
--query 'Labels[].Name' \
--output text