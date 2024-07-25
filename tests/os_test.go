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

func TestOsSles15(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "sles15"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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

func TestOsSleMicro55(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "slemicro55"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
func TestOsRhel8Cis(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "rhel8cis"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
func TestOsRhel8(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "rhel8"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
func TestOsRhel9(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "rhel9"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
func TestOsRocky8(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "rocky8"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
func TestOsLiberty7(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "liberty7"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
func TestOsUbuntu20(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "ubuntu20"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
func TestOsUbuntu22(t *testing.T) {
	t.Parallel()
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueId()
	}
	uniqueID := id + "-" + random.UniqueId()
	category := "os"
	directory := "ubuntu22"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair, terraformOptions)
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
