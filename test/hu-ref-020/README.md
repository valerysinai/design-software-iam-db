# Fixtures IAM para HU-REF-020

`prepare.sql` se ejecuta mediante el servicio `fixtures` del runner de `docker-infra/validation/hu-ref-020`. Primero deben aplicarse los changelogs oficiales con los contextos de DDL, DML, DCL y `dev`.

El script no agrega cambios de esquema ni reemplaza migraciones. Reutiliza las dos cuentas `.test` del seed HU-REF-018, les asigna la contraseña aleatoria recibida por la variable `FIXTURE_PASSWORD` y elimina el requisito de cambio de contraseña para esa ejecución automatizada. Verifica la presencia de ambas cuentas y se niega a actuar sobre una base cuyo nombre no sea `hu_ref_020`.

La salida muestra las columnas de contraseña temporal, `identity.outbox` y los roles ADMIN_STAFF/LEARNER. No imprime la contraseña ni el JWT. El resto de la prueba obtiene el token mediante login HTTP en IAM y valida su uso en Reference Data.

Estas fixtures son exclusivas del entorno local de integración; no ejecutar este procedimiento sobre bases compartidas o de producción.
