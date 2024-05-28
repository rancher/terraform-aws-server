#!/bin/bash

TYPE="$1"
if [ -z "$TYPE" ]; then echo "Usage: $0 <type>"; exit 1; fi

NAME="$(curl -qs  https://susepubliccloudinfo.suse.com/v1/amazon/images | jq '.images[] | 
  select(.state == "active") | 
  select(.region | contains("us-")) |
  select(.name | contains("sapcal") | not) |
  select(.name | contains("hvm-ssd-x86_64")) |
  select(.name | contains("'$TYPE'"))' |
  jq -s 'unique_by(.name)' |
  jq -r '.[].name')"

aws ec2 describe-images --filter="Name=name,Values=$NAME" | jq -r '.Images[0]'
