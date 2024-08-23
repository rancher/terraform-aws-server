#!/bin/bash

run_tests() {
  echo "" > /tmp/$IDENTIFIER_test.log
  if [ -d "./test" ]; then
    cd test || exit 1
  fi
  if [ -d "./tests" ]; then
    cd tests || exit 1
  fi
  cat <<'EOF'> /tmp/$IDENTIFIER_test-processor
echo "Passed: "
jq -r '. | select(.Action == "pass") | select(.Test != null).Test' /tmp/$IDENTIFIER_test.log
echo " "
echo "Failed: "
jq -r '. | select(.Action == "fail") | select(.Test != null).Test' /tmp/$IDENTIFIER_test.log
echo " "
EOF
  chmod +x /tmp/$IDENTIFIER_test-processor

  gotestsum \
    --format=standard-verbose \
    --jsonfile /tmp/$IDENTIFIER_test.log \
    --post-run-command "bash /tmp/$IDENTIFIER_test-processor" \
    -- \
    -parallel=4 \
    -timeout=300m \
    "$@"
}
if [ "" =  "$IDENTIFIER" ]; then
  IDENTIFIER="$(echo a-$RANDOM-d | base64 | tr -d '=')"
  export IDENTIFIER
fi
echo "id is: $IDENTIFIER..."
run_tests "$@"
# echo "Clearing leftovers with Id $IDENTIFIER in $AWS_REGION..."
# if [ "" != "$IDENTIFIER" ]; then
#   while [ "" != "$(leftovers -d --iaas=aws --aws-region="$AWS_REGION" --filter="Id:$IDENTIFIER")" ]; do
#     leftovers --iaas=aws --aws-region="$AWS_REGION" --filter="Id:$IDENTIFIER" --no-confirm
#   done
#   while [ "" != "$(leftovers -d --iaas=aws --aws-region="$AWS_REGION" --type="ec2-key-pair" --filter="tf-$IDENTIFIER")" ]; do
#     leftovers --iaas=aws --aws-region="$AWS_REGION" --type="ec2-key-pair" --filter="tf-$IDENTIFIER" --no-confirm
#   done
# fi
# echo "done"
