package terraform_region_check

import future.keywords.if

# Por defecto, no permitimos
default allow = false

# La regla debe devolver un booleano simple 'true' para que el grep 'true' funcione
allow if {
    some i
    provider := input.configuration.provider_config[i]
    provider.name == "aws"
    
    # Extraemos la región del plan
    region := provider.expressions.region.constant_value
    region == "us-east-1"
}

# 3. La decisión final: allow es true SOLO si no hay mensajes en deny
allow if {
    count(deny) == 0
}
