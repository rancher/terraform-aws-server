package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestOsSles15(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "sles15"
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
}
func TestOsSles15Byos(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "sles15byos"
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
}

func TestOsSles15Cis(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "sles15cis"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndPlan(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
// This test is commented out because it can only be run on an account who can subscribe to the image listed.
// func TestOsSleMicro54LLC(t *testing.T) {
// 	uniqueID := os.Getenv("IDENTIFIER")
// 	if uniqueID == "" {
// 		uniqueID = random.UniqueId()
// 	}
// 	category := "os"
// 	directory := "slemicro54llc"
// 	region := "us-west-1"
// 	owner := "terraform-ci@suse.com"
// 	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

// 	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
// 	defer sshAgent.Stop()
// 	terraformOptions.SshAgent = sshAgent

// 	defer teardown(t, category, directory, keyPair)
// 	defer terraform.Destroy(t, terraformOptions)
// 	terraform.InitAndPlan(t, terraformOptions)
// 	terraform.InitAndApply(t, terraformOptions)
// }
func TestOsSleMicro55LTD(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "slemicro55ltd"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndPlan(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestOsSleMicro55Byos(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "slemicro55byos"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndPlan(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestOsRhel8Cis(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "rhel8cis"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair := setup(t, category, directory, region, owner, uniqueID)

	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair.KeyPair)
	defer sshAgent.Stop()
	terraformOptions.SshAgent = sshAgent

	defer teardown(t, category, directory, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndPlan(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestOsRhel8(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "rhel8"
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
}
func TestOsRhel9(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "rhel9"
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
}
func TestOsRocky8(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "rocky8"
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
}
func TestOsLiberty7(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "liberty7"
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
}
func TestOsUbuntu20(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "ubuntu20"
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
}
func TestOsUbuntu22(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category := "os"
	directory := "ubuntu22"
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
}
