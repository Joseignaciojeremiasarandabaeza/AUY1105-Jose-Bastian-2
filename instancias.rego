package terraform.analysis


violation[msg] {
    some i
    resource := input.resource_changes[i]
    
    
    resource.type == "aws_instance"
    
    
    instance_type := resource.change.after.instance_type
    
   
    instance_type != "t2.micro"
    
    msg := sprintf("Costo/Estandarización: La instancia '%v' tiene un tipo prohibido (%v). Solo se permite 't2.micro'.", [resource.address, instance_type])
}


violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    not resource.change.after.tags.Name
    msg := sprintf("Seguridad: La instancia '%v' no tiene el tag 'Name' definido.", [resource.address])
}
