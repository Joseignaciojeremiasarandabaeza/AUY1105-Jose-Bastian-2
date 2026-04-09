package terraform.authz

import future.keywords.if

# Por defecto no permitimos
default allow = false

# Permitir si el nombre cumple con el estándar
allow if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    
    actual_name := instance.change.after.tags.Name
    actual_name == "AUY1105-duocapp-ec2"
}
