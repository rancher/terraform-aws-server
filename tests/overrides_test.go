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
func TestSelectAll(t *testing.T) {
	// in this test we are going to select everything in the server module and create nothing
	t.Parallel()
	category := "overrides"
	directory := "select_all"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"

	// multi part terraform, setup is an independent module in the test directory that sets up this test
	setupDirectory := fmt.Sprintf("%s/setup", directory)
	setupTerraformOptions, setupKeyPair := setup(t, category, setupDirectory, region, owner)
	setupSshAgent := ssh.SshAgentWithKeyPair(t, setupKeyPair.KeyPair)
	setupTerraformOptions.SshAgent = setupSshAgent
	defer setupSshAgent.Stop()
	defer teardown(t, category, setupDirectory, setupKeyPair)
	defer terraform.Destroy(t, setupTerraformOptions)
	terraform.InitAndApply(t, setupTerraformOptions)
	output := terraform.Output(t, setupTerraformOptions, "id")

	// after setup completes we can run the actual test, passing in the server id from setup
	terraformOptions, keyPair := setup(t, category, directory, region, owner)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	terraformOptions.SshAgent = sshAgent
	defer sshAgent.Stop()
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraformOptions.Vars["server"] = output
	terraform.InitAndApply(t, terraformOptions)
}
func TestAssociation(t *testing.T) {
	// in this test we are going to select everything in the server module, but force the association of a new security group onto the selected server
	t.Parallel()
	category := "overrides"
	directory := "association"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"

	// multi part terraform, setup is an independent module in the test directory that sets up this test
	setupDirectory := fmt.Sprintf("%s/setup", directory)
	setupTerraformOptions, setupKeyPair := setup(t, category, setupDirectory, region, owner)
	setupSshAgent := ssh.SshAgentWithKeyPair(t, setupKeyPair.KeyPair)
	setupTerraformOptions.SshAgent = setupSshAgent
	defer setupSshAgent.Stop()
	defer teardown(t, category, setupDirectory, setupKeyPair)
	defer terraform.Destroy(t, setupTerraformOptions)
	terraform.InitAndApply(t, setupTerraformOptions)
	output := terraform.Output(t, setupTerraformOptions, "id")

	// after setup completes we can run the actual test, passing in the server id from setup
	terraformOptions, keyPair := setup(t, category, directory, region, owner)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	terraformOptions.SshAgent = sshAgent
	defer sshAgent.Stop()
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraformOptions.Vars["server"] = output
	terraform.InitAndApply(t, terraformOptions)
}
