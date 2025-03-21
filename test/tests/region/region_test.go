package region

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
  util "github.com/rancher/terraform-aws-server/test/tests"
)

func TestRegionUsEast1(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "region"
	directory := "useast1"
	region := "us-east-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestRegionUsEast2(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "region"
	directory := "useast2"
	region := "us-east-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestRegionUsWest1(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "region"
	directory := "uswest1"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestRegionUsWest2(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "region"
	directory := "uswest2"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
