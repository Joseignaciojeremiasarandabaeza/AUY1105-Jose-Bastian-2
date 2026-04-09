package terraform.analysis

violation[msg] {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    not resource.change.after.tags.Name
    msg := sprintf("Seguridad: La instancia '%v' no tiene el tag 'Name' definido.", [resource.address])
}
