package terraform.analysis

import future.keywords.if
import future.keywords.contains

# 1. Regla para el tipo de instancia
violation contains msg if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    actual_type := instance.change.after.instance_type
    actual_type != "t2.micro"
    msg := sprintf("COSTOS: Tipo de instancia no permitido: %v. Solo se permite t2.micro", [actual_type])
}

# 2. Regla para los Tags (Nombre existente)
violation contains msg if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    tags := instance.change.after.tags
    not tags.Name
    msg := "ETIQUETADO: La instancia debe tener un tag 'Name'"
}

# 3. Regla para Tag Name no vacío
violation contains msg if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    tags := instance.change.after.tags
    tags.Name == ""
    msg := "ETIQUETADO: El tag 'Name' no puede estar vacío"
}

# 4. Regla para SSH Abierto (Unificada a la sintaxis 'contains')
violation contains msg if {
    some i
    # Cambiamos a resource_changes para ser consistentes con las reglas de arriba
    resource := input.resource_changes[i]
    resource.type == "aws_security_group"
    
    some j
    ingress := resource.change.after.ingress[j]
    ingress.from_port <= 22
    ingress.to_port >= 22
    
    some k
    ingress.cidr_blocks[k] == "0.0.0.0/0"
    
    msg := sprintf("SEGURIDAD: El Security Group '%s' permite SSH (puerto 22) desde el mundo (0.0.0.0/0).", [resource.name])
}