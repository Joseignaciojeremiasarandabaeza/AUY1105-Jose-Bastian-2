package terraform_region_check

# 1. Por defecto, no permitimos si no se cumplen las reglas
default allow = false

# 2. Definimos las denegaciones
deny[msg] {
    provider := input.provider_configurations[_]
    provider.type == "aws"
    # Usamos este formato para manejar valores nulos o faltantes de forma segura
    region := provider.configuration.region
    region != "us-east-1"
    msg := sprintf("Región no permitida: se encontró '%v', pero se requiere 'us-east-1'.", [region])
}

# 3. La decisión final: allow es true SOLO si no hay mensajes en deny
allow {
    count(deny) == 0
}
