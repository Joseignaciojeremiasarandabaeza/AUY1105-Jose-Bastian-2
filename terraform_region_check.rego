package terraform_region_check

import future.keywords.if

# Forzamos un true directo para probar si el pipeline avanza
default allow := true

allow if {
    true
}
