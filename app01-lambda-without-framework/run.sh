# 1o create policy file
touch policies.json

# 2o create role lambda security in AWS Account
aws iam create-role \
  --role-name lambda-exemplo \
  --assume-role-policy-document file://policies.json \
  | tee logs/role.log


# 3o create file with content and zip
zip function.zip index.js

# 3.1o create lambda function with zipped function file

aws lambda create-function \
  --function-name hello-cli \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs14.x \
  --role arn:aws:iam::343875642545:role/lambda-exemplo \
  | tee logs/lambda-create.log

  #4o invoke lambda to see result

  aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec.log

  #5o updating a lambda function

  #5.1o update function and zip it
  zip function.zip index.js

  #5.2o update lambda function with the new zipped file
  aws lambda update-function-code \
    --zip-file fileb://function.zip \
    --function-name hello-cli \
    --publish \
    | tee logs/lambda-update.log

  #5.3o invoke lambda to see result

  aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec-update.log


  #6o delete lambda function and role
  aws lambda delete-function \
    --function-name hello-cli

  aws iam delete-role \
    --role-name lambda-exemplo