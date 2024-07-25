package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicBasic(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "basic"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}

func TestBasicDualstack(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "dualstack"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	delete(terraformOptions.Vars, "key_name")
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestBasicPrivateIp(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "privateip"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
}
func TestBasicIndirectOnly(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "indirectonly"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
}
func TestBasicIndirectDomain(t *testing.T) {
	t.Parallel()
	zone := os.Getenv("ZONE")
	acmeserver := os.Getenv("ACME_SERVER_URL")
	if acmeserver == "" {
		os.Setenv("ACME_SERVER_URL", "https://acme-staging-v02.api.letsencrypt.org/directory")
	}
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "indirectdomain"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraformOptions.Vars["zone"] = zone
	terraform.InitAndApply(t, terraformOptions)
}

func TestBasicDirectNetworkOnly(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "directnetworkonly"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
}

func TestBasicDirectNetworkDomain(t *testing.T) {
	t.Parallel()
	zone := os.Getenv("ZONE")
	acmeserver := os.Getenv("ACME_SERVER_URL")
	if acmeserver == "" {
		os.Setenv("ACME_SERVER_URL", "https://acme-staging-v02.api.letsencrypt.org/directory")
	}
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "directnetworkdomain"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)
	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraformOptions.Vars["zone"] = zone
	terraform.InitAndApply(t, terraformOptions)
}

func TestBasicDirectSshEip(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "directssheip"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndPlan(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	out := terraform.OutputAll(t, terraformOptions)
	t.Logf("out: %v", out)
	outputServer, ok := out["server"].(map[string]interface{})
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'server', expected map[string], got %T", out["server"]))
	outputImage, ok := out["image"].(map[string]interface{})
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'image', expected map[string], got %T", out["image"]))
	assert.NotEmpty(t, outputServer["public_ip"], "The 'server.public_ip' is empty")
	assert.NotEmpty(t, outputImage["id"], "The 'image.id' is empty")
}

func TestBasicDirectSshSubnet(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "basic"
	directory := "directsshsubnet"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndPlan(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	out := terraform.OutputAll(t, terraformOptions)
	t.Logf("out: %v", out)
	outputServer, ok := out["server"].(map[string]interface{})
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'server', expected map[string], got %T", out["server"]))
	outputImage, ok := out["image"].(map[string]interface{})
	assert.True(t, ok, fmt.Sprintf("Wrong data type for 'image', expected map[string], got %T", out["image"]))
	assert.NotEmpty(t, outputServer["public_ip"], "The 'server.public_ip' is empty")
	assert.NotEmpty(t, outputImage["id"], "The 'image.id' is empty")
}
