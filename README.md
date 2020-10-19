# Cloudfront Invalidation Action
> Github action to invalidate one or more Cloudfront distributions cache

[![NPM Version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Downloads Stats][npm-downloads]][npm-url]

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
testingyaml:
    tested: true

```

