# AUY1105-Jose-Bastian-2

El objetivo principal de esta evaluación es implementar un pipeline automatizado mediante GitHub Actions, integrando herramientas de análisis
de calidad, seguridad y prácticas modernas de infraestructura como código (IaC). Este flujo de trabajo deberá cumplir con los estándares de
seguridad, calidad y mantenibilidad, a la vez que permita a los equipos gestionar la infraestructura de manera eficiente y escalable.

- instrucciones basicas
*git clone (clonación del repositorio)
*mkdir para crear carpetas

-instrucciónes del primer punto a realizar de la evaluación

Nombre del repositorio: El repositorio tendrá como nombre <sigla-curso>-grupo-<Nª de grupo>.
 Archivo README.md: Se debe detallar los objetivos del repositorio, instrucciones básicas de uso y propósito general. Además de la
definición del código Terraform.
 Archivo .gitignore: Asegurarse de excluir archivos no deseados, por ejemplo, directorios .terraform, secrets, o claves privadas.
 Archivo CHANGELOG.md: Asegurarse de documentar todos los cambios realizados sobre el proyecto.

 Archivo ec2.tf: Creacion de la instancia junto a securyti group
 Archivo vpc.tf: Creacion de la vpc. las subredes privadas y publicas, junto al igw y el nat 
 Archivo provider: Le dice al codigo de donde sacar la sintaxis y a donde va.
  .Gitignore: se agrego el .pem
 Archivos .rego: conkfiguran las politicas del opa para la creacion de instancias