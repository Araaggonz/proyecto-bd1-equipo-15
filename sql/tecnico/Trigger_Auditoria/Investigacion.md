# Trigger_auditoria

## Definición y funcionamiento

Un trigger (o disparador) es un bloque de código SQL que se activa automáticamente cuando ocurre un evento determinado en una tabla, vista o incluso en la base de datos/servidor
Estos eventos suelen ser operaciones de modificación de datos como INSERT, UPDATE o DELETE, aunque también pueden ser cambios en la estructura de la base de datos (DDL) o eventos de inicio de sesión
La ejecución del trigger es automática y no requiere intervención del usuario.

## Tipos de triggers
DML (Data Manipulation Language): Se activan por operaciones de manipulación de datos, como inserciones, actualizaciones o eliminaciones en tablas o vistas

DDL (Data Definition Language): Se disparan ante cambios en la estructura de la base de datos, como crear, modificar o eliminar tablas

AFTER: Se ejecutan después de que la operación se completa exitosamente, útiles para auditorías o actualizaciones en cascada

BEFORE: Se ejecutan antes de que la operación ocurra, permitiendo validar o modificar datos antes de la acción

INSTEAD OF: Reemplazan la operación original, ejecutándose en lugar de la instrucción de inserción, actualización o eliminación, especialmente en vistas

## Aplicaciones prácticas

Los triggers se utilizan para:

* Mantener la integridad de los datos y aplicar reglas de negocio complejas

* Automatizar tareas como cálculos, actualizaciones en cascada o auditorías

* Registrar cambios en tablas de auditoría o historial de datos

* Generar valores derivados automáticamente o notificaciones a sistemas externos


## VENTAJAS
* Generan automáticamente algunos valores de columna derivados.
* Aplicar la integridad referencial.
* Registro de eventos y almacenamiento de información sobre el acceso a la tabla.
* Auditoría.
* Replicación sincrónica de tablas.
* Imponer autorizaciones de seguridad.
* Prevenir transacciones inválidas.


## Utilizacion en la etapa 5

Para esta estapa se realizaron trigger para contemplar las siguientes cuestiones que forman parte de las reglas de negocio

- Registro de precios históricos.

- Generación y conservación del comprobante de venta.

- Gestión de stock: El sistema debe gestionar el stock disponible de cada producto, garantizando que no pueda ser negativo. Al realizar una venta, el stock debe        reducirse según las cantidades vendidas y no se debe permitir una venta que supere las existencias disponibles.

- Toda compra debe estar asociada a un proveedor registrado y, al confirmarse la recepción, las cantidades adquiridas deben incrementar el stock correspondiente.

- Stock mínimo: El sistema debe permitir establecer un nivel de stock mínimo para cada producto. Cuando las existencias alcancen o queden por debajo de dicho límite,  el producto debe identificarse para su reposición.

- Cada merma debe indicar fecha, cantidad y motivo, y debe descontarse del stock sin asociarse a una venta.

### Auditoría

Se realizo un trigger de auditorias por cada update o delete sobre una tabla  que pueda registrar en una tabla auxiliar los valores de los registros antes de un borrado o modificación de cualquier dato, mas la fecha, hora y usario de la base de datos que realizo la operación.

Además un trigger que al intentar realizar un delete sobre una tabla emita un mensaje y no permita realizar la operación.

Todas estas consultas se hiceron las pruebas de funcionamiento y verificacion de que devuelvan los resultados necesarios y correctos.

## CONCLUSION
Los triggers en SQL son muy útiles cuando necesitamos disparar eventos de forma automática cuando ocurre algún eventos automáticamente cuando ocurre un evento importante para nosotros, como una inserción (INSERT) en una tabla de intereses. De esta forma, los valores de otras tablas deberían actualizarse automáticamente y podemos lograrlo con triggers.

