package terraform.analysis

import future.keywords.if
import future.keywords.contains

# Regla para el tipo de instancia
violation contains msg if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    actual_type := instance.change.after.instance_type
    actual_type != "t2.micro"
    msg := sprintf("Tipo de instancia no permitido: %v. Solo se permite t2.micro", [actual_type])
}

# Regla para los Tags (Nombre)
violation contains msg if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    tags := instance.change.after.tags
    not tags.Name
    msg := "La instancia debe tener un tag 'Name'"
}

# Regla para Tags específicos (Opcional, según tus requisitos)
violation contains msg if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    tags := instance.change.after.tags
    tags.Name == ""
    msg := "El tag 'Name' no puede estar vacío"
}


# Regla para detectar violaciones de SSH abierto
violation[msg] {
    some i
    resource := input.planned_values.root_module.resources[i]
    resource.type == "aws_security_group"
    
    # Buscamos en las reglas de entrada (ingress)
    ingress := resource.values.ingress[j]
    ingress.from_port <= 22
    ingress.to_port >= 22
    ingress.protocol == "tcp"
    
    # Verificamos si el CIDR es el "mundo" (0.0.0.0/0)
    some k
    ingress.cidr_blocks[k] == "0.0.0.0/0"
    
    msg := sprintf("SEGURIDAD: El Security Group '%s' permite SSH (puerto 22) desde 0.0.0.0/0. Esto está prohibido.", [resource.name])
}
