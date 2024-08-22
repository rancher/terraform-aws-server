package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSizeSmall(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "size"
	directory := "small"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestSizeMedium(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "size"
	directory := "medium"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestSizeLarge(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "size"
	directory := "large"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestSizeXL(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "size"
	directory := "xl"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestSizeXXL(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "size"
	directory := "xxl"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
