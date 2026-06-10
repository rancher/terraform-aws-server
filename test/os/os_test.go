package os_test

import (
	"fmt"
	"os"
	"reflect"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/rancher/terraform-aws-server/test"
	"github.com/stretchr/testify/assert"
)

func TestOs(t *testing.T) {
	id := os.Getenv("IDENTIFIER")
	if id == "" {
		id = random.UniqueID()
	}
	uniqueID := id + "-" + random.UniqueID()
	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "us-west-2"
	}
	owner := "terraform-ci@suse.com"
	imageType := os.Getenv("IMAGE")

	// get the image list from the imagetype example
	category := "imagetype"
	directory := "basic"
	imageTypesTerraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
	sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
	// don't pass key or key_name to the image module
	delete(imageTypesTerraformOptions.Vars, "key")
	delete(imageTypesTerraformOptions.Vars, "key_name")
	_, err := terraform.InitAndApplyContextE(t, t.Context(), imageTypesTerraformOptions)
	if err != nil {
		util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, imageTypesTerraformOptions)
		t.Error(err)
		t.Fail()
	}
	info := terraform.OutputMapContext(t, t.Context(), imageTypesTerraformOptions, "image_names")
	images := keys(info)
	util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, imageTypesTerraformOptions)
	for k := range images {
		image := images[k].String()
		if imageType != "" && imageType != image {
			continue
		}

		t.Run(image, func(t *testing.T) {
			t.Parallel()
			t.Logf("Running test for %s", image)
			uniqueID := id + "-" + random.UniqueID()
			category := "os"
			directory := "all"
			terraformOptions, keyPair := util.Setup(t, category, directory, region, owner, uniqueID)
			sshAgent := ssh.SSHAgentWithKeyPair(t, t.Context(), keyPair.KeyPair)
			terraformOptions.SshAgent = sshAgent
			terraformOptions.Vars["image"] = image
			_, err := terraform.InitAndApplyContextE(t, t.Context(), terraformOptions)
			if err != nil {
				util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
				t.Error(err)
				t.Fail()
			}
			out := terraform.OutputAllContext(t, t.Context(), terraformOptions)
			t.Logf("out: %v", out)
			outputServer, ok := out["server"].(map[string]any)
			assert.True(t, ok, fmt.Sprintf("Wrong data type for 'server', expected map[string], got %T", out["server"]))
			outputImage, ok := out["image"].(map[string]any)
			assert.True(t, ok, fmt.Sprintf("Wrong data type for 'image', expected map[string], got %T", out["image"]))
			assert.NotEmpty(t, outputServer["public_ip"], "The 'server.public_ip' is empty")
			assert.NotEmpty(t, outputImage["id"], "The 'image.id' is empty")

			// Validate SSH connection and user setup
			publicIP, ok := outputServer["public_ip"].(string)
			assert.True(t, ok, "public_ip is not a string")
			identifier := terraformOptions.Vars["identifier"].(string)
			username := strings.ToLower(fmt.Sprintf("tf-%s", identifier))
			if len(username) > 32 {
				username = username[:32]
			}

			host := ssh.Host{
				Hostname:    publicIP,
				SshUserName: username,
				SshKeyPair:  keyPair.KeyPair,
			}

			// Test SSH connection
			t.Logf("Testing SSH connection to %s@%s", username, publicIP)
			result := ssh.CheckSSHCommandContext(t, t.Context(), &host, "whoami")
			assert.Contains(t, result, username, "SSH connection failed or returned unexpected user")

			// Test sudo access
			t.Logf("Testing sudo access for %s", username)
			sudoResult := ssh.CheckSSHCommandContext(t, t.Context(), &host, "sudo whoami")
			assert.Contains(t, sudoResult, "root", "Sudo access failed")

			util.Teardown(t, category, directory, keyPair, sshAgent, uniqueID, terraformOptions)
		})
	}
}

func keys(m map[string]string) []reflect.Value {
	return reflect.ValueOf(m).MapKeys()
}
