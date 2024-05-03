package test

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"

	a "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	aws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func teardown(t *testing.T, category string, directory string, keyPair *aws.Ec2Keypair) {
	files, err := filepath.Glob(fmt.Sprintf("../examples/%s/%s/.terraform*", category, directory))
	require.NoError(t, err)
	for _, f := range files {
		err1 := os.RemoveAll(f)
		require.NoError(t, err1)
	}
	files, err2 := filepath.Glob(fmt.Sprintf("../examples/%s/%s/terraform.*", category, directory))
	require.NoError(t, err2)
	for _, f := range files {
		err3 := os.RemoveAll(f)
		require.NoError(t, err3)
	}

	aws.DeleteEC2KeyPair(t, keyPair)
}

func setup(t *testing.T, category string, directory string, region string, owner string, uniqueID string) (*terraform.Options, *aws.Ec2Keypair) {

	// Create an EC2 KeyPair that we can use for SSH access
	keyPairName := fmt.Sprintf("terraform-aws-server-%s-%s-%s", category, directory, uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, region, keyPairName)

	// tag the key pair so we can find in the access module
	client, err1 := aws.NewEc2ClientE(t, region)
	require.NoError(t, err1)

	input := &ec2.DescribeKeyPairsInput{
		KeyNames: []*string{a.String(keyPairName)},
	}
	result, err2 := client.DescribeKeyPairs(input)
	require.NoError(t, err2)

	aws.AddTagsToResource(t, region, *result.KeyPairs[0].KeyPairId, map[string]string{"Name": keyPairName, "Owner": owner})

	retryableTerraformErrors := map[string]string{
		// The reason is unknown, but eventually these succeed after a few retries.
		".*unable to verify signature.*":             "Failed due to transient network error.",
		".*unable to verify checksum.*":              "Failed due to transient network error.",
		".*no provider exists with the given name.*": "Failed due to transient network error.",
		".*registry service is unreachable.*":        "Failed due to transient network error.",
		".*connection reset by peer.*":               "Failed due to transient network error.",
		".*TLS handshake timeout.*":                  "Failed due to transient network error.",
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf("../examples/%s/%s", category, directory),
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"key":        keyPair.KeyPair.PublicKey,
			"key_name":  keyPairName,
			"identifier": uniqueID,
		},
		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
		},
		RetryableTerraformErrors: retryableTerraformErrors,
	})
	return terraformOptions, keyPair
}
