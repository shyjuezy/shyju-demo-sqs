#!/usr/bin/env bash

echo "===> Building src"
mkdir -p build
cp -r src/* build/

SERVICE_NAME=${PWD##*/}
REGIONS=(
  "us-east-1"
)

echo $AWS_ACCOUNT
echo $SERVICE_NAME
echo $REGIONS

echo "===> Deploying"
for REGION in ${REGIONS[@]}; do
  echo "===> Packaging and deploy for $REGION"
  OUTPUT_FILE=packaged-$SERVICE_NAME-$REGION.yml

  sam package \
    --template-file template.yml \
    --region $REGION \
    --s3-bucket shyju-firstbucket \
    --output-template-file $OUTPUT_FILE \
    --capabilities CAPABILITY_NAMED_IAM \
    --profile my-profile

  if [ -z "$1" ]
  then
    sam package \
      --template-file $OUTPUT_FILE \
      --region $REGION \
      --s3-bucket shyju-firstbucket \
      --output-template-file $OUTPUT_FILE \
      --capabilities CAPABILITY_NAMED_IAM \
      --profile my-profile
  else
    sam deploy \
      --no-fail-on-empty-changeset \
      --template-file $OUTPUT_FILE \
      --stack-name $1-$SERVICE_NAME \
      --region $REGION \
      --s3-bucket shyju-firstbucket \
      --capabilities CAPABILITY_NAMED_IAM \
      --parameter-overrides AliasName="${1}" \
      --profile my-profile
  fi
done
