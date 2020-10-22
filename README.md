# Cloudfront Invalidation Action
> Github action to invalidate one or more Cloudfront distributions cache

This action was maded to invalidate one or more Cloudfront distributions cache.
This action needs a txt file stored on s3 bucket with the Cloudfront distributions IDs

Example:

```txt
CLOUDFRONTID1
CLOUDFRONTID2
CLOUDFRONTID3
...
```

## Usage example

```yaml
name: Invalidate Cloudfront

on:
  push:
    branches: [ main ]

jobs:
  invalidation:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Invalidate cloudfront
        uses: thiagocerq/cloudfront-invalidations@v1
        env:
          DISTRIBUTIONS_FILE: ${{ secrets.DISTRIBUTIONS_FILE }} # Syntax for the secret: <bucketName>/<filePath>
          PATHS: |
            /index.html
            /assets/*
            /wp-includes/*
          AWS_REGION: ${{ secrets.AWS_REGION }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

```

## Properties

| Property | Required? |
| ------ | ------ |
| DISTRIBUTIONS_FILE | yes |
| PATHS | yes (one or more) |
| AWS_REGION | yes |
| AWS_ACCESS_KEY_ID | yes |
| AWS_SECRET_ACCESS_KEY | yes |

