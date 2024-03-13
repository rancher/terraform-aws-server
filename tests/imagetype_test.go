package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestImageTypesBasic(t *testing.T) {
	t.Parallel()
	category := "imagetype"
	directory := "basic"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)

	rhel8 := terraform.OutputMap(t, terraformOptions, "rhel-8")
	rhel8Cis := terraform.OutputMap(t, terraformOptions, "rhel-8-cis")
	rhel9 := terraform.OutputMap(t, terraformOptions, "rhel-9")
	rocky8 := terraform.OutputMap(t, terraformOptions, "rocky-8")
	sles15 := terraform.OutputMap(t, terraformOptions, "sles-15")
	sles15Cis := terraform.OutputMap(t, terraformOptions, "sles-15-cis")
	ubuntu20 := terraform.OutputMap(t, terraformOptions, "ubuntu-20")
	ubuntu22 := terraform.OutputMap(t, terraformOptions, "ubuntu-22")

	// Validate the names of the images
	assert.Contains(t, rhel8["name"], "RHEL", "RHEL image name should contain 'RHEL'")
	assert.Contains(t, rhel8Cis["name"], "CIS Red Hat", "RHEL image name should contain 'CIS Red Hat'")
	assert.Contains(t, rhel9["name"], "RHEL", "RHEL image name should contain 'RHEL'")
	assert.Contains(t, rocky8["name"], "Rocky", "Rocky image name should contain 'Rocky'")
	assert.Contains(t, sles15["name"], "sles", "SLES image name should contain 'sles'")
	assert.Contains(t, sles15Cis["name"], "CIS SUSE", "SLES image name should contain 'CIS SUSE'")
	assert.Contains(t, ubuntu20["name"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, ubuntu22["name"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
}
