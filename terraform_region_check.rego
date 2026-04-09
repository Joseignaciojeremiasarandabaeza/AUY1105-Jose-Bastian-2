package terraform_region_check

default allow = true

# Verifica que el provider de Terraform use la región east-us-1 (Virginia)
deny[msg] {
    provider := input.provider_configurations[_]
    provider.type == "aws"
    provider.configuration.region != "us-east-1"
    msg := sprintf("El provider AWS debe usar la región us-east-1 (Virginia), se encontró %v", [provider.configuration.region])
}

allow = false {
    deny[_]
    msg := "Region no correcta"
}