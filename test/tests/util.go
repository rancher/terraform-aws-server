package test

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	a "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	aws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/git"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func Teardown(t *testing.T, category string, directory string, keyPair *aws.Ec2Keypair, agent *ssh.SshAgent, id string, terraformOptions *terraform.Options) {

	_, err := terraform.DestroyE(t, terraformOptions)
	if err != nil {
		if strings.Contains(err.Error(), "operation error EC2: DisassociateAddress") {
			t.Logf("Ignored error while destroying cluster: %s", err)
		}
		t.Fatalf("Error destroying cluster: %s", err)
	}

	gwd := git.GetRepoRoot(t)      // git working directory
	fwd, err4 := filepath.Abs(gwd) // full working directory
	if err4 != nil {
		require.NoError(t, err4)
	}
	testDataDir := fwd + "/tests/data/" + id
	err5 := os.RemoveAll(testDataDir)
	require.NoError(t, err5)
	aws.DeleteEC2KeyPair(t, keyPair)
	agent.Stop()
}

func Setup(t *testing.T, category string, directory string, region string, owner string, uniqueID string) (*terraform.Options, *aws.Ec2Keypair) {

	// Create an EC2 KeyPair that we can use for SSH access
	keyPairName := fmt.Sprintf("tf-%s-%s-%s", category, directory, uniqueID)
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
		".*unable to verify signature.*":               "Failed due to transient network error.",
		".*unable to verify checksum.*":                "Failed due to transient network error.",
		".*no provider exists with the given name.*":   "Failed due to transient network error.",
		".*registry service is unreachable.*":          "Failed due to transient network error.",
		".*connection reset by peer.*":                 "Failed due to transient network error.",
		".*TLS handshake timeout.*":                    "Failed due to transient network error.",
		".*operation error EC2: DisassociateAddress.*": "Failed due to transient AWS reconcile error.",
	}
	gwd := git.GetRepoRoot(t)      // git root dir
	fgd, err3 := filepath.Abs(gwd) // full git root dir
	if err3 != nil {
		require.NoError(t, err3)
	}
	testDataDir := fgd + "/test/data/" + uniqueID

	err4 := os.Mkdir(fgd + "/test/data", 0755)
	if err4 != nil && !os.IsExist(err4) {
		require.NoError(t, err4)
	}
	err5 := os.Mkdir(testDataDir, 0755)
	if err5 != nil && !os.IsExist(err4) {
		require.NoError(t, err5)
	}

	files, err6 := filepath.Glob(fmt.Sprintf("%s/examples/%s/%s/*", fgd, category, directory))
	require.NoError(t, err6)
	for _, f := range files {
		// copy all the files to the test data dir to prevent collisions
    // the number of parent directories to repo root must be the same as in the example
    //   this is because the module source is a relative path '../../../'
		fileName := strings.Split(f, "/")[len(strings.Split(f, "/"))-1]
		err7 := os.Link(f, fmt.Sprintf("%s/%s", testDataDir, fileName))
		require.NoError(t, err7)
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
    // example files are copied to the test directory
		TerraformDir: testDataDir,
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"key":        keyPair.KeyPair.PublicKey,
			"key_name":   keyPairName,
			"identifier": uniqueID,
		},
		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
			"TF_IN_AUTOMATION":   "1",
		},
		RetryableTerraformErrors: retryableTerraformErrors,
	})
	return terraformOptions, keyPair
}
