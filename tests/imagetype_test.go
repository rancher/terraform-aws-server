package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestImageTypeBasic(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category 	:= "imagetype"
	directory := "basic"
	region 		:= "us-west-1"
	owner 		:= "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner, uniqueID)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
	info := terraform.OutputMap(t, terraformOptions, "image_info")
	// Validate the names of the images
	assert.Contains(t, info["sles-15"], "suse-sles-15-sp5", "SLES image name should contain 'suse-sles-15-sp5'")
	assert.Contains(t, info["sle-micro-55"], "suse-sle-micro-5-5", "SLE Micro image name should contain 'suse-sle-micro-5-5'")
	assert.Contains(t, info["rhel-8-cis"], "CIS Red Hat", "RHEL image name should contain 'CIS Red Hat'")
	assert.Contains(t, info["ubuntu-20"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["ubuntu-22"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["rocky-8"], "Rocky", "Rocky image name should contain 'Rocky'")
	assert.Contains(t, info["liberty-7"], "liberty", "Liberty 7 image name should contain 'liberty'")
	assert.Contains(t, info["rhel-8"], "RHEL", "RHEL image name should contain 'RHEL'")
	assert.Contains(t, info["rhel-9"], "RHEL", "RHEL image name should contain 'RHEL'")
}

func TestImageTypeCustom(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category 	:= "imagetype"
	directory := "custom"
	region 		:= "us-west-1"
	owner 		:= "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner, uniqueID)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
}

func TestImageTypeSelect(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category 	:= "imagetype"
	directory := "select"
	region 		:= "us-west-1"
	owner 		:= "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner, uniqueID)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
}

func TestImageTypeUsEast1(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category 	:= "imagetype"
	directory := "useast1"
	region 		:= "us-east-1"
	owner 		:= "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner, uniqueID)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
	info := terraform.OutputMap(t, terraformOptions, "image_info")
	// Validate the names of the images
	assert.Contains(t, info["sles-15"], "suse-sles-15-sp5", "SLES image name should contain 'suse-sles-15-sp5'")
	assert.Contains(t, info["sle-micro-55"], "suse-sle-micro-5-5", "SLE Micro image name should contain 'suse-sle-micro-5-5'")
	assert.Contains(t, info["rhel-8-cis"], "CIS Red Hat", "RHEL image name should contain 'CIS Red Hat'")
	assert.Contains(t, info["ubuntu-20"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["ubuntu-22"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["rocky-8"], "Rocky", "Rocky image name should contain 'Rocky'")
	assert.Contains(t, info["liberty-7"], "liberty", "Liberty 7 image name should contain 'liberty'")
	assert.Contains(t, info["rhel-8"], "RHEL", "RHEL image name should contain 'RHEL'")
	assert.Contains(t, info["rhel-9"], "RHEL", "RHEL image name should contain 'RHEL'")
}
func TestImageTypeUsEast2(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category 	:= "imagetype"
	directory := "useast2"
	region 		:= "us-east-2"
	owner 		:= "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner, uniqueID)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
	info := terraform.OutputMap(t, terraformOptions, "image_info")
	// Validate the names of the images
	assert.Contains(t, info["sles-15"], "suse-sles-15-sp5", "SLES image name should contain 'suse-sles-15-sp5'")
	assert.Contains(t, info["sle-micro-55"], "suse-sle-micro-5-5", "SLE Micro image name should contain 'suse-sle-micro-5-5'")
	assert.Contains(t, info["rhel-8-cis"], "CIS Red Hat", "RHEL image name should contain 'CIS Red Hat'")
	assert.Contains(t, info["ubuntu-20"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["ubuntu-22"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["rocky-8"], "Rocky", "Rocky image name should contain 'Rocky'")
	assert.Contains(t, info["liberty-7"], "liberty", "Liberty 7 image name should contain 'liberty'")
	assert.Contains(t, info["rhel-8"], "RHEL", "RHEL image name should contain 'RHEL'")
	assert.Contains(t, info["rhel-9"], "RHEL", "RHEL image name should contain 'RHEL'")
}

func TestImageTypeUsWest1(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category 	:= "imagetype"
	directory := "uswest1"
	region 		:= "us-west-1"
	owner 		:= "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner, uniqueID)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
	info := terraform.OutputMap(t, terraformOptions, "image_info")
	// Validate the names of the images
	assert.Contains(t, info["sles-15"], "suse-sles-15-sp5", "SLES image name should contain 'suse-sles-15-sp5'")
	assert.Contains(t, info["sle-micro-55"], "suse-sle-micro-5-5", "SLE Micro image name should contain 'suse-sle-micro-5-5'")
	assert.Contains(t, info["rhel-8-cis"], "CIS Red Hat", "RHEL image name should contain 'CIS Red Hat'")
	assert.Contains(t, info["ubuntu-20"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["ubuntu-22"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["rocky-8"], "Rocky", "Rocky image name should contain 'Rocky'")
	assert.Contains(t, info["liberty-7"], "liberty", "Liberty 7 image name should contain 'liberty'")
	assert.Contains(t, info["rhel-8"], "RHEL", "RHEL image name should contain 'RHEL'")
	assert.Contains(t, info["rhel-9"], "RHEL", "RHEL image name should contain 'RHEL'")
}
func TestImageTypeUsWest2(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER") + "-" + random.UniqueId()
	category 	:= "imagetype"
	directory := "uswest2"
	region 		:= "us-west-2"
	owner 		:= "terraform-ci@suse.com"
	terraformOptions, keypair := setup(t, category, directory, region, owner, uniqueID)

	defer teardown(t, category, directory, keypair)
	defer terraform.Destroy(t, terraformOptions)
	// don't pass key or key_name to the module
	delete(terraformOptions.Vars, "key")
	delete(terraformOptions.Vars, "key_name")
	terraform.InitAndApply(t, terraformOptions)
	info := terraform.OutputMap(t, terraformOptions, "image_info")
	// Validate the names of the images
	assert.Contains(t, info["sles-15"], "suse-sles-15-sp5", "SLES image name should contain 'suse-sles-15-sp5'")
	assert.Contains(t, info["sle-micro-55"], "suse-sle-micro-5-5", "SLE Micro image name should contain 'suse-sle-micro-5-5'")
	assert.Contains(t, info["rhel-8-cis"], "CIS Red Hat", "RHEL image name should contain 'CIS Red Hat'")
	assert.Contains(t, info["ubuntu-20"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["ubuntu-22"], "ubuntu", "Ubuntu image name should contain 'ubuntu'")
	assert.Contains(t, info["rocky-8"], "Rocky", "Rocky image name should contain 'Rocky'")
	assert.Contains(t, info["liberty-7"], "liberty", "Liberty 7 image name should contain 'liberty'")
	assert.Contains(t, info["rhel-8"], "RHEL", "RHEL image name should contain 'RHEL'")
	assert.Contains(t, info["rhel-9"], "RHEL", "RHEL image name should contain 'RHEL'")
}
