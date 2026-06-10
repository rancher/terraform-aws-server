package basic

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/rancher/terraform-aws-server/test"
	"github.com/stretchr/testify/assert"
)

func TestBasicBasic(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "basic"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}

func TestBasicDualstack(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "dualstack"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	terraformOptions.SshAgent = sshAgent

	delete(terraformOptions.Vars, "key_name")
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestBasicPrivateIp(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "privateip"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestBasicIndirectOnly(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "indirectonly"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
func TestBasicIndirectDomain(t *testing.T) {
	t.Parallel()
	zone := os.Getenv("ZONE")
	acmeserver := os.Getenv("ACME_SERVER_URL")
	if acmeserver == "" {
		err := os.Setenv("ACME_SERVER_URL", "https://acme-staging-v02.api.letsencrypt.org/directory")
		if err != nil {
			t.Fatal(err)
		}
	}
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "indirectdomain"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraformOptions.Vars["zone"] = zone
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}

func TestBasicDirectNetworkOnly(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "directnetworkonly"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}

func TestBasicDirectNetworkDomain(t *testing.T) {
	t.Parallel()
	zone := os.Getenv("ZONE")
	acmeserver := os.Getenv("ACME_SERVER_URL")
	if acmeserver == "" {
		err := os.Setenv("ACME_SERVER_URL", "https://acme-staging-v02.api.letsencrypt.org/directory")
		if err != nil {
			t.Fatal(err)
		}
	}
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "directnetworkdomain"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraformOptions.Vars["zone"] = zone
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}

func TestBasicDirectSshEip(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "directssheip"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	terraformOptions.SshAgent = sshAgent

	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndPlanContext(t, t.Context(), terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)

	out := terraform.OutputAllContext(t, t.Context(), terraformOptions)
	t.Logf("out: %v", out)
	outputServer, ok := out["server"].(map[string]any)
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'server', expected map[string], got %T", out["server"]))
	outputImage, ok := out["image"].(map[string]any)
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'image', expected map[string], got %T", out["image"]))
	assert.NotEmpty(t, outputServer["public_ip"], "The 'server.public_ip' is empty")
	assert.NotEmpty(t, outputImage["id"], "The 'image.id' is empty")
}

func TestBasicDirectSshSubnet(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	category := "basic"
	directory := "directsshsubnet"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	terraformOptions.SshAgent = sshAgent

	defer util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndPlanContext(t, t.Context(), terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)

	out := terraform.OutputAllContext(t, t.Context(), terraformOptions)
	t.Logf("out: %v", out)
	outputServer, ok := out["server"].(map[string]any)
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'server', expected map[string], got %T", out["server"]))
	outputImage, ok := out["image"].(map[string]any)
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'image', expected map[string], got %T", out["image"]))
	assert.NotEmpty(t, outputServer["public_ip"], "The 'server.public_ip' is empty")
	assert.NotEmpty(t, outputImage["id"], "The 'image.id' is empty")
}
