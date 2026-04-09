package terraform_region_check

import future.keywords.if

# 1. Definimos que por defecto el acceso está denegado
default allow := false

# 2. Definimos la regla de permitir: 
# Debe ser un booleano simple 'true' para que tu pipeline lo detecte
allow := true if {
    some i
    provider := input.configuration.provider_config[i]
    provider.name == "aws"
    
    # Validamos que la región sea estrictamente us-east-1
    region := provider.expressions.region.constant_value
    region == "us-east-1"
}
