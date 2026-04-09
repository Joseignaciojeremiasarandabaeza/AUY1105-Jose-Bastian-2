package terraform_region_check

import future.keywords.if

# Por defecto, no permitimos
default allow := false

# Permitir solo si la región es us-east-1
allow := true if {
    some i
    provider := input.configuration.provider_config[i]
    provider.name == "aws"
    
    # Buscamos la región en el plan
    region := get_region(provider)
    region == "us-east-1"
}

# Función para extraer la región sin importar si es variable o texto plano
get_region(p) := r if {
    r := p.expressions.region.constant_value
} else := r if {
    var_name := replace(p.expressions.region.references[0], "var.", "")
    r := input.configuration.root_module.variables[var_name].default
}
