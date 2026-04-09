package terraform_region_check

import future.keywords.if

default allow := false

# Esta versión busca la región de forma más flexible
allow := true if {
    some i
    provider := input.configuration.provider_config[i]
    provider.name == "aws"
    
    # Intentamos obtener la región desde constant_value (directo) 
    # o desde references (si usas variables)
    region := get_region(provider)
    region == "us-east-1"
}

# Función auxiliar para extraer la región
get_region(p) := r if {
    r := p.expressions.region.constant_value
} else := r if {
    # Si usas una variable var.region, buscamos el valor por defecto
    var_name := replace(p.expressions.region.references[0], "var.", "")
    r := input.configuration.root_module.variables[var_name].default
}
