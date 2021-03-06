
get_bucket() {
  local bucket=$(echo "$payload" | jq -r '.source.bucket')
  test -z "$bucket" && { echo "Must supply source.bucket" >&2; exit 1; }
  echo $bucket
}

get_prefix() {
  local prefix=$(echo "$payload" | jq -r '.params.prefix // ""')
  if [ -n "$prefix" ]; then
    prefix=$(eval echo $prefix) # Resolve variables like $BUILD_NAME, etc.
  fi
  echo $prefix
}

export_aws_vars() {
  local access_key_id=$(echo "$payload" | jq -r '.source.access_key_id // empty')
  local secret_access_key=$(echo "$payload" | jq -r '.source.secret_access_key // empty')
  local default_region=$(echo "$payload" | jq -r '.source.region // empty')

  if [ -n "$access_key_id" ] && [ -n "$secret_access_key" ]; then
    export AWS_ACCESS_KEY_ID=$access_key_id
    export AWS_SECRET_ACCESS_KEY=$secret_access_key
  fi

  if [ -n "$default_region" ]; then
    export AWS_DEFAULT_REGION=$default_region
  fi
}

emit_version() {
  echo "{\"version\": {}}" >&3
}
