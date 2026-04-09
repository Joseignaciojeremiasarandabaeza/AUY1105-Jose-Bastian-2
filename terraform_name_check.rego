package terraform.analysis

# Regla para validar el nombre exacto
violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    actual_name := resource.change.after.tags.Name
    actual_name != "AUY1105-duocapp-ec2"
    
    msg := sprintf("Estandarización: El nombre '%v' es incorrecto. Debe ser 'AUY1105-duocapp-ec2'.", [actual_name])
}

# Regla para validar el tipo de instancia
violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    resource.change.after.instance_type != "t2.micro"
    msg := "Costo: Solo se permite el tipo t2.micro."
}
