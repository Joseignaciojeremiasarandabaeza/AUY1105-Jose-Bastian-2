# Primera parte

1. se crea los archivos principales de nuestro repositorio
- README.MD
- CHANGELOG.md

2. Código de infraestructura 

- vpc.tf ( se guarda la informacion y version de nustra AWS )
- subredes ( se agrega la información de las subredes ejemplo puertos)
- Security Groups ( encargados de controlar el trafico )
- EC2 ( se añade la version y tipo de instancia )
- Provider (Se configura el provedor)
- instancias (crea una politica en opa que verifica que solo se puedan crear instancias t2.micro)
- terraform_region (Verifica que el provider de Terraform use la región east-us-1 )
- terraform_name (verifica el nombre de la instancia)