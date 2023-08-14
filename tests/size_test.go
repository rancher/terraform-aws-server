package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSmall(t *testing.T) {
	// in this test we are going to create a small server
	t.Parallel()
	category := "size"
	directory := "small"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestMedium(t *testing.T) {
	// in this test we are going to create a medium server
	t.Parallel()
	category := "size"
	directory := "medium"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestLarge(t *testing.T) {
	// in this test we are going to create a large server
	t.Parallel()
	category := "size"
	directory := "large"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestXl(t *testing.T) {
	// in this test we are going to create a extra large server
	t.Parallel()
	category := "size"
	directory := "xl"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestXxl(t *testing.T) {
	// in this test we are going to create a extra-extra large server
	t.Parallel()
	category := "size"
	directory := "xxl"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
