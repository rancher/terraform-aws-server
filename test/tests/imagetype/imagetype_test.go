package imagetype

import (
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
  util "github.com/rancher/terraform-aws-server/test/tests"
)

func TestImageTypeBasic(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "imagetype"
	directory := "basic"
	owner := "terraform-ci@suse.com"
	// region := "us-west-1"
	regions := [...]string{"us-west-1", "us-west-2", "us-east-1", "us-east-2"}
	for r := range regions {
		terraformOptions, keyPair := util.Setup(t, category, directory, regions[r], owner, uniqueID)
		sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
		// don't pass key or key_name to the module
		delete(terraformOptions.Vars, "key")
		delete(terraformOptions.Vars, "key_name")
		_, err := terraform.InitAndApplyE(t, terraformOptions)
		if err != nil {
			util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
			t.Error(err)
			t.Fail()
		}
		info := terraform.OutputMap(t, terraformOptions, "image_names")
		// Validate the names of the images
		for k, v := range info {
			assert.Contains(t, strings.ToLower(v), strings.Split(k, "-")[0], "Aws image name should contain our image name")
			t.Logf("AWS Image %s contains %s", strings.ToLower(v), strings.Split(k, "-")[0])
		}
		util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	}
}

func TestImageTypeCustom(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "imagetype"
	directory := "custom"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
}
