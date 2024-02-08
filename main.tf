
resource "spacelift_stack" "example-stack" {
  name = var.new_stack_name
  administrative    = true
  autodeploy        = false
  branch            = "master"
  description       = "Shared production infrastructure"
  repository        = "testing-spacelift"
  terraform_version = "0.12.27"
}


resource "spacelift_stack" "main_stack" {
  name       = var.main_stack
  branch     = "main"
  repository = "sapcelift_with_terraform"
}

resource "spacelift_stack" "dev_stack" {
  name       = var.dev_stack
  branch     = "dev"
  repository = "sapcelift_with_terraform"
}


#==============Policy ===================================

resource "spacelift_policy" "illegal_ports" {
  name = "Policy-01"
  body = file("${path.module}/policy/no-illegal-ports.rego")
  type = "PLAN"
}

resource "spacelift_policy" "enforce_cloud_provider" {
  name = "Policy-02"
  body = file("${path.module}/policy/enforce-cloud-provider.rego")
  type = "PLAN"
}

resource "spacelift_policy" "instance_size_policy" {
  name = "Policy-03"
  body = file("${path.module}/policy/instance-size-policy.rego")
  type = "PLAN"
}


#==============Attach Policy to stack "example-stack" ===================================
resource "spacelift_policy_attachment" "illegal_ports_attachment" {
  policy_id = spacelift_policy.illegal_ports.id
  stack_id  = spacelift_stack.example-stack.id
}
resource "spacelift_policy_attachment" "enforce_cloud_provider_attachment" {
  policy_id = spacelift_policy.enforce_cloud_provider.id
  stack_id  = spacelift_stack.example-stack.id
}
resource "spacelift_policy_attachment" "instance_size_policy_attachment" {
  policy_id = spacelift_policy.instance_size_policy.id
  stack_id  = spacelift_stack.example-stack.id
}

# #==============Attach Policy to stack "main_stack" ======================================
# resource "spacelift_policy_attachment" "illegal_ports_attachment" {
#   policy_id = spacelift_policy.illegal_ports.id
#   stack_id  = spacelift_stack.main_stack.id
# }
# resource "spacelift_policy_attachment" "enforce_cloud_provider_attachment" {
#   policy_id = spacelift_policy.enforce_cloud_provider.id
#   stack_id  = spacelift_stack.main_stack.id
# }
# resource "spacelift_policy_attachment" "instance_size_policy_attachment" {
#   policy_id = spacelift_policy.instance_size_policy.id
#   stack_id  = spacelift_stack.main_stack.id
# }


# #==============Attach Policy to stack "dev_stack" ====================================

# resource "spacelift_policy_attachment" "illegal_ports_attachment" {
#   policy_id = spacelift_policy.illegal_ports.id
#   stack_id  = spacelift_stack.dev_stack.id
# }
# resource "spacelift_policy_attachment" "enforce_cloud_provider_attachment" {
#   policy_id = spacelift_policy.enforce_cloud_provider.id
#   stack_id  = spacelift_stack.dev_stack.id
# }
# resource "spacelift_policy_attachment" "instance_size_policy_attachment" {
#   policy_id = spacelift_policy.instance_size_policy.id
#   stack_id  = spacelift_stack.dev_stack.id
# }
