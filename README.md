# Simple S3 Resource for [Concourse CI](http://concourse.ci)

Resource to upload files to S3. Unlike the [the official S3 Resource](https://github.com/concourse/s3-resource), this Resource can upload or download multiple files.

## Usage

Include the following in your Pipeline YAML file, replacing the values in the angle brackets (`< >`):

```yaml
resource_types:
- name: s3-bucket
  type: docker-image
  source:
    repository: troykinsella/s3-resource-simple

resources:
- name: s3
  type: s3-bucket
  source:
    access_key_id: ((aws_access_key)) # Optional
    secret_access_key: ((aws_secret_key)) # Optional
    bucket: my-bucket
    region: us-east-1 # Optional
    aws_options: "--endpoint-url https://objects-us-east-1.dream.io" # Optional

jobs:
- name: publish-files
  plan:
  - task: Generate some files
    output_mapping:
      files: s3-upload
  - put: s3
    params:
      prefix: /my-s3-dir # Optional
      source_dir: s3-upload
```

## AWS Credentials

The `access_key_id` and `secret_access_key` are optional and if not provided the EC2 Metadata service will be queried for role based credentials.

## Options

The `options` parameter is synonymous with the options that `aws cli` accepts for `sync`. 
Please see [S3 Sync Options](http://docs.aws.amazon.com/cli/latest/reference/s3/sync.html#options) 
and pay special attention to the 
[Use of Exclude and Include Filters](http://docs.aws.amazon.com/cli/latest/reference/s3/index.html#use-of-exclude-and-include-filters).

Given the following directory `test`:

```
test
├── results
│   ├── 1.json
│   └── 2.json
└── scripts
    └── bad.sh
```

We can upload _only_ the `results` subdirectory by using the following `options` in our task configuration:

```yaml
options:
- "--exclude '*'"
- "--include 'results/*'"
```

The `aws_options` source parameter supplies options to the `aws` executable 
(whereas the `options` parameter supplies options to the `aws sync` command.)

### Region
Interacting with some AWS regions (like London) requires AWS Signature Version
4. This options allows you to explicitly specify region where your bucket is
located (if this is set, AWS_DEFAULT_REGION env variable will be set accordingly).

```yaml
region: eu-west-2
```
