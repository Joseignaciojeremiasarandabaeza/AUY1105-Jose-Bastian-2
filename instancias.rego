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
