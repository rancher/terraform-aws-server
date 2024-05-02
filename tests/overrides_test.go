package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestServerOnly(t *testing.T) {
	// in this test we are going to create a server without touching the image module
	t.Parallel()
	//domain := os.Getenv("DOMAIN")
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}

	category := "overrides"
	directory := "server_only"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

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
func TestOverridesSelect(t *testing.T) {
	// in this test we are going to select everything in the server module and create nothing
	t.Parallel()
	//domain := os.Getenv("DOMAIN")
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	category := "overrides"
	directory := "select_all"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"

	// multi part terraform, setup is an independent module in the test directory that sets up this test
	setupDirectory := fmt.Sprintf("%s/setup", directory)
	setupTerraformOptions, setupKeyPair := setup(t, category, setupDirectory, region, owner, uniqueID)
	setupSshAgent := ssh.SshAgentWithKeyPair(t, setupKeyPair.KeyPair)
	setupTerraformOptions.SshAgent = setupSshAgent
	defer setupSshAgent.Stop()
	defer teardown(t, category, setupDirectory, setupKeyPair)
	defer terraform.Destroy(t, setupTerraformOptions)
	terraform.InitAndApply(t, setupTerraformOptions)
	output := terraform.Output(t, setupTerraformOptions, "id")

	// after setup completes we can run the actual test, passing in the server id from setup
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraformOptions.Vars["server"] = output
	delete(terraformOptions.Vars, "key_name")
	delete(terraformOptions.Vars, "key")
	terraform.InitAndApply(t, terraformOptions)
}
func TestAssociation(t *testing.T) {
	// in this test we are going to select everything in the server module, but force the association of a new security group onto the selected server
	t.Parallel()
	//domain := os.Getenv("DOMAIN")
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	category := "overrides"
	directory := "association"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"

	// multi part terraform, setup is an independent module in the test directory that sets up this test
	setupDirectory := fmt.Sprintf("%s/setup", directory)
	setupTerraformOptions, setupKeyPair := setup(t, category, setupDirectory, region, owner, uniqueID)
	setupSshAgent := ssh.SshAgentWithKeyPair(t, setupKeyPair.KeyPair)
	setupTerraformOptions.SshAgent = setupSshAgent
	defer setupSshAgent.Stop()
	defer teardown(t, category, setupDirectory, setupKeyPair)
	defer terraform.Destroy(t, setupTerraformOptions)
	terraform.InitAndApply(t, setupTerraformOptions)
	serverId := terraform.Output(t, setupTerraformOptions, "id")
	uniqueId := terraform.Output(t, setupTerraformOptions, "identifier")
	keyName := terraform.Output(t, setupTerraformOptions, "key_name")

	// after setup completes we can run the actual test, passing in the server id from setup
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueId)
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraformOptions.Vars["identifier"] = uniqueId
	terraformOptions.Vars["server"] = serverId
	terraformOptions.Vars["key_name"] = keyName
	delete(terraformOptions.Vars, "key")
	terraform.InitAndApply(t, terraformOptions)
}
