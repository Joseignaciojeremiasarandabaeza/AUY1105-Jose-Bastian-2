package terraform.analysis

# 1. Validación del Tipo de Instancia
violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    # Obtenemos el tipo de instancia (manejando si es nulo)
    instance_type := resource.change.after.instance_type
    instance_type != "t2.micro"
    
    msg := sprintf("Costo: La instancia '%v' usa '%v'. Solo se permite t2.micro.", [resource.address, instance_type])
}

# 2. Validación del Tag Name (Más flexible)
violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    # Buscamos el tag Name en 'tags' o en 'tags_all'
    tags := resource.change.after.tags
    not tags.Name
    
    msg := sprintf("Seguridad: La instancia '%v' no tiene el tag 'Name' definido.", [resource.address])
}

# 3. Validación del Valor del Tag Name
violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    actual_name := resource.change.after.tags.Name
    actual_name != "AUY1105-duocapp-ec2"
    
    msg := sprintf("Estandarización: El nombre '%v' es incorrecto. Debe ser 'AUY1105-duocapp-ec2'.", [actual_name])
}
    
    # Verificamos que el tag Name exista en el bloque 'after'
    not resource.change.after.tags.Name
    msg := sprintf("Seguridad: La instancia '%v' no tiene el tag 'Name'.", [resource.address])
}
