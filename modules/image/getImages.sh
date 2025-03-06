#!/bin/bash

group_by_region=false
objects=false
type=""

while getopts ":t:r:o:" opt; do
  case $opt in
    t) type="$OPTARG" ;;
    r) group_by_region=true ;;
    o) objects=true ;;
    \?) echo "Invalid option -$OPTARG" >&2 && exit 1 ;;
  esac
done

if [ -z "$type" ]; then echo 'type (-t) required'; exit 1; fi

declare -a regions
declare -a image_names
declare -a image_objects


for region in $(cat regions.txt); do
  export AWS_REGION="$region"

  # echo "looking in region: $AWS_REGION OR $AWS_DEFAULT_REGION"
  if [ "sle-micro" = "$type" ] || [ "sles" = "$type" ] || [ "liberty" = "$type" ]; then
    # valid SUSE types
    NAME="$(
      curl -qs  https://susepubliccloudinfo.suse.com/v1/amazon/images | jq '.images[] |
        select(.state == "active") |
        select(.region | contains("us-")) |
        select(.name | contains("sapcal") | not) |
        select(.name | contains("x86_64")) |
        select(.name | contains("'"$type"'"))' |
        jq -s 'unique_by(.name)' |
        jq -r '.[].name'
    )"
    for n in $NAME; do
      IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=$n" | jq -r '.Images[0]')"
      if [ "null" != "$IMAGE" ]; then
        image_names+=("$(jq -r '.Name' <<< "$IMAGE")")
        image_objects+=("$IMAGE")
      fi
    done
  elif [ "rhel-9" = "$type" ]; then
      IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=RHEL-9.*" | jq -r '.Images[0]')"
      if [ "null" != "$IMAGE" ]; then
        image_names+=("$(jq -r '.Name' <<< "$IMAGE")")
        image_objects+=("$IMAGE")
      fi
  elif [ "cis"  = "$type" ]; then
      IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=CIS*STIG*" | jq -r '.Images')"
      if [ "null" != "$IMAGE" ]; then
        image_names+=("$(jq -r '.[].Name' <<< "$IMAGE")")
        image_objects+=("$IMAGE")
      fi
  elif [ "ubuntu"  = "$type" ]; then
      IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=ubuntu/images/*/ubuntu-*-*.04-amd64-server-*" | jq -r '.Images')"
      if [ "null" != "$IMAGE" ]; then
        image_names+=("$(jq -r '.[].Name' <<< "$IMAGE")")
        image_objects+=("$IMAGE")
      fi
  elif [ "rocky"  = "$type" ]; then
      # example: Rocky-8-EC2-Base-8.9-20231119.0.x86_64-d6577ceb-8ea8-4e0e-84c6-f098fc302e82
      # product code: cotnnspjrsi38lfn8qo4ibnnm
      # example: Rocky-9-EC2-LVM-9.4-20240523.0.x86_64-prod-hyj6jp3bki4bm
      # product code: c0tjzp9xnxvr0ah4f0yletr6b

      # V="$(echo "$type" | awk -F- '{print $2}')"
      IMAGE="$(aws ec2 describe-images --filter="Name=name,Values=Rocky-*-EC2-Base-*.*-*.*.x86_64-*" | jq -r '.Images')"
      if [ "null" != "$IMAGE" ]; then
        NAMES="$(jq -r '.[].Name' <<< "$IMAGE")"
        # echo "Name --- OwnerId"
        for n in $NAMES; do
          OWNER="$(jq -r '.[] | select(.Name == "'"$n"'") | .OwnerId' <<< "$IMAGE")"
          # echo "$n    $OWNER"
          image_names+=("$n")
          image_obects+=("$IMAGE")
        done
      fi
  else
    # invalid type
    echo "$type isn't a valid type"
    echo "current valid types are:"
    echo "sle-micro, sles, liberty, ubuntu, rhel-9, cis, rocky"
  fi

  if [ $group_by_region ]; then
    for i in "${images[@]}"; do
      echo "$i-$region"
    done
  fi

done

if [ ! $objects ]; then
  # echo "sorted and uniq..."
  IFS=$'\n' sorted=($(sort <<<"${image_names[*]}" | uniq))
  unset IFS
  # echo "${#images[*]} images found"
  for i in "${sorted[@]}"; do
    echo "$i"
  done
else
  for i in "${image_objects[@]}"; do
    echo "$i"
  done
fi
