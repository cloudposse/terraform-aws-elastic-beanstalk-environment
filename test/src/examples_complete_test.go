package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	// Give this S3 Bucket a unique ID for a name tag so we can distinguish it from any other Buckets provisioned
	// in your AWS account
	attribute := []string{strings.ToLower(random.UniqueId())}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attribute,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	expectedName := fmt.Sprintf("eg-test-elastic-beanstalk-env-%s", attribute[:0])
	elasticBeanstalkApplicationName := terraform.Output(t, terraformOptions, "elastic_beanstalk_application_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedName, elasticBeanstalkApplicationName)

	// Run `terraform output` to get the value of an output variable
	elasticBeanstalkEnvironmentName := terraform.Output(t, terraformOptions, "elastic_beanstalk_environment_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedName, elasticBeanstalkEnvironmentName)

	// Run `terraform output` to get the value of an output variable
	elasticBeanstalkEnvironmentHostname := terraform.Output(t, terraformOptions, "elastic_beanstalk_environment_hostname")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "elastic-beanstalk-env.testing.cloudposse.co", elasticBeanstalkEnvironmentHostname)
}
