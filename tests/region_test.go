package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func TestUsEast1(t *testing.T) {
	// in this test we are going to create a server in the us-east-1 region
	t.Parallel()
	category := "region"
	directory := "useast1"
	region := "us-east-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestUsEast2(t *testing.T) {
	// in this test we are going to create a server in the us-east-2 region
	t.Parallel()
	category := "region"
	directory := "useast2"
	region := "us-east-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestUsWest1(t *testing.T) {
	// in this test we are going to create a server in the us-west-1 region
	t.Parallel()
	category := "region"
	directory := "uswest1"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestUsWest2(t *testing.T) {
	// in this test we are going to create a server in the us-west-2 region
	t.Parallel()
	category := "region"
	directory := "uswest2"
	region := "us-west-2"
	owner := "terraform-ci@suse.com"
	terraformOptions, keyPair, sshAgent := setup(t, category, directory, region, owner)
	defer teardown(t, category, directory, keyPair, sshAgent)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
