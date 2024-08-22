#!/bin/bash
echo "looking in region: $AWS_REGION OR $AWS_DEFAULT_REGION"
TYPE="$1"
if [ -z "$TYPE" ]; then echo "Usage: $0 <type>"; exit 1; fi

if [ "sle-micro" = "$TYPE" ] || [ "sles" = "$TYPE" ] || [ "liberty" = "$TYPE" ]; then
  # valid SUSE types
  NAME="$(
    curl -qs  https://susepubliccloudinfo.suse.com/v1/amazon/images | jq '.images[] |
      select(.state == "active") |
      select(.region | contains("us-")) |
      select(.name | contains("sapcal") | not) |
      select(.name | contains("x86_64")) |
      select(.name | contains("'$TYPE'"))' |
      jq -s 'unique_by(.name)' |
      jq -r '.[].name'
  )"
  for n in $NAME; do
    IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=$n" | jq -r '.Images[0]')"
    if [ "null" != "$IMAGE" ]; then
      jq -r '.Name' <<< "$IMAGE"
    fi
  done
elif [ "rhel-9" = "$TYPE" ]; then
    IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=RHEL-9.*" | jq -r '.Images[0]')"
    if [ "null" != "$IMAGE" ]; then
      jq -r '.Name' <<< "$IMAGE"
    fi
elif [ "cis"  = "$TYPE" ]; then
    IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=CIS*STIG*" | jq -r '.Images')"
    if [ "null" != "$IMAGE" ]; then
      jq -r '.[].Name' <<< "$IMAGE"
    fi
elif [ "ubuntu-22"  = "$TYPE" ] || [ "ubuntu-24" = "$TYPE" ]; then
    V="$(echo $TYPE | awk -F- '{print $2}')"
    IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=ubuntu/images/*/ubuntu-*-$V.04-amd64-server-*" | jq -r '.Images')"
    if [ "null" != "$IMAGE" ]; then
      jq -r '.[].Name' <<< "$IMAGE"
    fi
elif [ "rocky-8"  = "$TYPE" ] || [ "rocky-9" = "$TYPE" ]; then
    # example: Rocky-8-EC2-Base-8.9-20231119.0.x86_64-d6577ceb-8ea8-4e0e-84c6-f098fc302e82
    # product code: cotnnspjrsi38lfn8qo4ibnnm
    # example: Rocky-9-EC2-LVM-9.4-20240523.0.x86_64-prod-hyj6jp3bki4bm
    # product code: c0tjzp9xnxvr0ah4f0yletr6b

    V="$(echo $TYPE | awk -F- '{print $2}')"
    IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=Rocky-$V-EC2-*-$V.*-*.*.x86_64-*" | jq -r '.Images')"
    if [ "null" != "$IMAGE" ]; then
      NAMES="$(jq -r '.[].Name' <<< "$IMAGE")"
      echo "Name --- OwnerId"
      for n in $NAMES; do
        OWNER="$(jq -r '.[] | select(.Name == "'$n'") | .OwnerId' <<< "$IMAGE")"
        echo "$n    $OWNER"
      done
    fi
else
  # invalid type
  echo "$TYPE isn't a valid type"
  echo "current valid types are:"
  echo "sle-micro, sles, liberty, ubuntu-24, ubuntu-22, rhel-9, cis"
fi
