package size

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/rancher/terraform-aws-server/test"
)

func TestSizeSmall(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueID()
	category := "size"
	directory := "small"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestSizeMedium(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueID()
	category := "size"
	directory := "medium"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestSizeLarge(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueID()
	category := "size"
	directory := "large"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestSizeXL(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueID()
	category := "size"
	directory := "xl"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestSizeXXL(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueID()
	category := "size"
	directory := "xxl"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestSizeXXXL(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueID()
	category := "size"
	directory := "xxxl"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
