package terraform.analysis

# Regla para el tipo de instancia
violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    # Comprobamos el valor que quedará DESPUÉS de aplicar el plan
    instance_type := resource.change.after.instance_type
    instance_type != "t2.micro"
    
    msg := sprintf("Costo: La instancia '%v' usa '%v'. Solo se permite 't2.micro'.", [resource.address, instance_type])
}

# Regla para el Tag Name
violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    # Verificamos que el tag Name exista en el bloque 'after'
    not resource.change.after.tags.Name
    msg := sprintf("Seguridad: La instancia '%v' no tiene el tag 'Name'.", [resource.address])
}
