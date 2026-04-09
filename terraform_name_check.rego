package terraform.authz

import future.keywords.if

default allow := {
    "status": false,
    "msg": "El nombre de la instancia no cumple la nomenclatura requerida (AUY1105-duocapp-ec2)."
}

allow := {
    "status": true,
    "msg": "Nombre de instancia validado correctamente."
} if {
    some i
    instance := input.resource_changes[i]
    instance.type == "aws_instance"
    
    actual_name := instance.change.after.tags.Name
    actual_name == "AUY1105-duocapp-ec2"
}
