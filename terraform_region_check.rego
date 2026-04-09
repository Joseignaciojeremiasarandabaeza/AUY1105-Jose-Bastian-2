package terraform_region_check

import future.keywords.if
import future.keywords.contains

# 1. Por defecto, no permitimos si no se cumplen las reglas
default allow = false

# 2. Definimos las denegaciones
# Cambiamos deny[msg] por deny contains msg
deny contains msg if {
    some i
    provider := input.configuration.provider_config[i]
    provider.name == "aws"
    
    # Extraemos la región de las expresiones
    region := provider.expressions.region.constant_value
    region != "us-east-1"
    
    msg := sprintf("Región no permitida: se encontró '%v', pero se requiere 'us-east-1'.", [region])
}

# 3. La decisión final: allow es true SOLO si no hay mensajes en deny
allow if {
    count(deny) == 0
}
