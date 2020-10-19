#!/bin/bash -l

set -eo pipefail

# check configuration

err=0

if [ -z "$DISTRIBUTIONS_FILE" ]; then
  echo "error: DISTRIBUTION_FILE is not set"
  err=1
fi

if [[ -z "$PATHS" && -z "$PATHS_FROM" ]]; then
  echo "error: PATHS or PATHS_FROM is not set"
  err=1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "error: AWS_ACCESS_KEY_ID is not set"
  err=1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "error: AWS_SECRET_ACCESS_KEY is not set"
  err=1
fi

if [ -z "$AWS_REGION" ]; then
  echo "error: AWS_REGION is not set"
  err=1
fi

if [ $err -eq 1 ]; then
  exit 1
fi

aws configure --profile invalidate-cloudfront <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF


if [ "$DEBUG" = "1" ]; then
  echo "*** Enabling debug output (set -x)"
  set -x
fi

if [[ -n "$PATHS_FROM" ]]; then
  echo "*** Reading PATHS from $PATHS_FROM"
  if [[ ! -f  $PATHS_FROM ]]; then
    echo "PATHS file not found. nothing to do. exiting"
    exit 0
  fi
  PATHS=$(cat $PATHS_FROM)
  echo "PATHS=$PATHS"
  if [[ -z "$PATHS" ]]; then
    echo "PATHS is empty. nothing to do. exiting"
    exit 0
  fi
fi

IFS=', ' read -r -a PATHS_ARR <<< "$PATHS"

aws --profile invalidate-cloudfront s3 cp s3://"$DISTRIBUTIONS_FILE" /distributions.file

input="/distributions.file"
while IFS= read -r line
do
  aws --profile invalidate-cloudfront \
  cloudfront create-invalidation \
  --distribution-id "$line" \
  --paths "${PATHS_ARR[@]}" \
  $*
done < "$input"