#!/bin/bash

# shellcheck disable=SC2317,SC2034
# shell check can't see that we are using these variables in the eval statement

TYPES="sles15 sles15cis rhel8cis ubuntu20 ubuntu22 rocky8 rhel9 rhel8"
REGIONS="us-west-1 us-west-2 us-east-1 us-east-2"

# IMPORTANT!! The filters in this file should match the filters in the module/image/types.tf
## please make sure to validate these image filters with QA


FILTER_sles15='[{"Name": "name", "Values": ["suse-sles-15-sp5-v2024*"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_sles15='["013907871322","679593333241"]'

FILTER_sles15cis='[{"Name": "name", "Values": ["CIS SUSE*15*"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_sles15cis='["679593333241"]'

FILTER_rhel8cis='[{"Name": "name", "Values": ["CIS Red Hat*8*STIG*"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_rhel8cis='["679593333241"]'

FILTER_ubuntu20='[{"Name": "name", "Values": ["ubuntu/images/*ubuntu-focal-20.04-amd64-server-2024*-*-*-*-*-*"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_ubuntu20='["679593333241","099720109477","513442679011","837727238323"]'

FILTER_ubuntu22='[{"Name": "name", "Values": ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-2024*-*-*-*-*-*"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_ubuntu22='["679593333241","099720109477","513442679011","837727238323"]'

FILTER_rocky8='[{"Name": "name", "Values": ["Rocky-8-*Base*.x86_64-*-*-*-*-*"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_rocky8='["679593333241"]'

FILTER_rhel9='[{"Name": "name", "Values": ["RHEL-9.3*_HVM-2024*-x86_64-*-Hourly2-GP3"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_rhel9='["309956199498"]'

FILTER_rhel8='[{"Name": "name", "Values": ["RHEL-8.9*_HVM-2024*-x86_64-*-Hourly2-GP3"]},{"Name": "architecture", "Values": ["x86_64"]}]'
OWNER_rhel8='["309956199498"]'

E=0

main() {
  for TYPE in $TYPES; do
    eval "region_check \"$TYPE\" \"\$FILTER_$TYPE\" \"\$OWNER_$TYPE\" \"\$REGIONS\""
  done
}

region_check() {
  TYPE="$1"
  FILTER="$2"
  OWNER="$3"
  REGIONS="$4"
  for REGION in $REGIONS; do
    image="$(find_image "$REGION" "$FILTER" "$OWNER")"
    if [ "null" = "$image" ]; then echo "no images found in $REGION for $TYPE"; E=1; return; fi
    if [ -z "$image" ]; then echo "no images found in $REGION for $TYPE"; E=1; return; fi
    id="$(jq '. | keys | .[0]' <<<"$image")"
    name="$(jq '.[].name' <<<"$image")"
    created="$(jq '.[].created' <<<"$image")"
    echo "image $id for $TYPE found in $REGION created at $created titled $name..."
  done
}

find_image() {
  region="$1"
  filter="$2"
  owner="$3"
  if [ -z "$region" ]; then echo "need region"; return; fi
  if [ -z "$filter" ]; then echo "need a filter"; return; fi
  if [ -z "$owner" ]; then echo "need an owner"; return; fi
  IMAGES="$(aws ec2 describe-images \
    --region="$region" \
    --filter="$filter" \
    --owners="$owner")"
  if [ -z "$IMAGES" ]; then echo "no images found..."; E=1; return; fi
  if [ "null" = "$IMAGES" ]; then echo "no images found..."; E=1; return; fi
  jq '.Images | sort_by(.CreationDate) | reverse | map({(.ImageId): { "name": .Name, "created": .CreationDate}}) | .[0]' <<<"$IMAGES"
}

main
exit $E