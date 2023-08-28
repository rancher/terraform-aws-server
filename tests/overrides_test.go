package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestServerOnly(t *testing.T) {
	// in this test we are going to create a server without touching the image module
	t.Parallel()
	category := "overrides"
	directory := "server_only"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestSelectImage(t *testing.T) {
	// in this test we are going to select an image without touching the server module
	t.Parallel()
	category := "overrides"
	directory := "select_image"
	region := "us-west-1"
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf("../examples/%s/%s", category, directory),
		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}

func TestSelectServer(t *testing.T) {
	// in this test we are going to select an image and a server without creating anything
	t.Parallel()
	category := "overrides"
	directory := "select_server"
	region := "us-west-1"
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf("../examples/%s/%s", category, directory),
		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
