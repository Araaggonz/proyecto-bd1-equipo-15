# Documetacion de Trigger - etapa 5

## 1. Introducción

En la base de datos `VERDE_ENCANTO`, correspondiente al sistema de gestión comercial de un vivero, se implementaron cinco triggers para automatizar el control del stock, registrar cambios realizados sobre los productos y restringir operaciones de eliminación.

Los triggers desarrollados son:

* `TR_producto_venta_insert`
* `TR_producto_compra_stock`
* `TR_merma_stock`
* `TR_auditoria_producto`
* `TR_bloquear_delete_categoria`

## 2. Trigger de actualización del stock por ventas

**Nombre:** `TR_producto_venta_insert`
**Tabla asociada:** `Producto_Venta`
**Operaciones:** `INSERT`, `UPDATE` y `DELETE`.

### Objetivo

Actualizar automáticamente el stock de los productos cuando se registran, modifican o eliminan detalles de venta.

### Funcionamiento

El trigger descuenta del stock las unidades correspondientes a los nuevos detalles de venta. Si se modifica la cantidad vendida, ajusta el stock teniendo en cuenta tanto el valor anterior como el nuevo. Si se elimina un detalle de venta, devuelve al stock las unidades que se habían descontado.

Además, verifica que la operación no provoque un stock negativo. Si esto ocurre, cancela la operación y muestra un mensaje de error.

### Pruebas realizadas

Se probaron las operaciones de inserción, modificación y eliminación de detalles de venta mediante transacciones con `ROLLBACK`.

También se comprobó que el trigger rechazara una operación que superaría las unidades disponibles.

Los resultados permitieron verificar que el stock se ajustaba correctamente en cada caso y que las pruebas no dejaban cambios permanentes en los datos originales.

## 3. Trigger de actualización del stock por compras

**Nombre:** `TR_producto_compra_stock`
**Tabla asociada:** `Producto_Compra`
**Operaciones:** `INSERT`, `UPDATE` y `DELETE`.

### Objetivo

Mantener actualizado el stock de los productos cuando se registran, modifican o eliminan detalles de compra.

### Funcionamiento

El trigger aumenta el stock según las cantidades incorporadas mediante los detalles de compra. Cuando se modifica una cantidad, calcula el ajuste considerando el valor anterior y el nuevo. Si se elimina un detalle de compra, descuenta del stock las unidades que se habían agregado.

También verifica que la operación no genere un stock negativo y, si detecta esta situación, cancela la operación y muestra un mensaje de error.

### Pruebas realizadas

Se probaron las operaciones de inserción, modificación y eliminación de detalles de compra utilizando transacciones con `ROLLBACK`.

Se verificó que las variaciones del stock fueran correctas y que, al deshacer las pruebas, los datos volvieran a sus valores originales.

## 4. Trigger de actualización del stock por mermas

**Nombre:** `TR_merma_stock`
**Tabla asociada:** `Merma`
**Operaciones:** `INSERT`, `UPDATE` y `DELETE`.

### Objetivo

Controlar las variaciones del stock producidas por mermas, como productos vencidos, dañados o deteriorados.

### Funcionamiento

Cuando se registra una merma, el trigger descuenta del stock la cantidad afectada. Si se modifica la cantidad de una merma, ajusta el stock según la diferencia entre el valor anterior y el nuevo. Si se elimina un registro de merma, devuelve al stock las unidades que se habían descontado.

El trigger también verifica que la operación no deje el stock en un valor negativo. Si esto sucediera, cancela la operación y genera un mensaje de error.

### Pruebas realizadas

Se probaron las operaciones de inserción, modificación y eliminación de mermas utilizando transacciones con `ROLLBACK`.

Los resultados permitieron comprobar que el stock se ajustaba correctamente en cada operación y que los datos originales se recuperaban al finalizar las pruebas.

## 5. Trigger de auditoría de productos

**Nombre:** `TR_auditoria_producto`
**Tabla asociada:** `Producto`
**Operaciones:** `UPDATE` y `DELETE`.

### Objetivo

Conservar un registro de los valores anteriores de los productos cuando se realizan modificaciones o eliminaciones, junto con información sobre cuándo y quién realizó la operación.

### Tabla auxiliar

Para almacenar la información histórica se creó la tabla `Auditoria_Producto`, que contiene:

* Identificador del registro de auditoría.
* Identificador del producto afectado.
* Nombre y descripción anteriores.
* Stock actual y stock mínimo anteriores.
* Estado y categoría anteriores.
* Tipo de operación realizada.
* Fecha y hora de la operación.
* Usuario de la base de datos que ejecutó la operación.

La tabla auxiliar no tiene una clave foránea hacia `Producto`, lo que permite conservar el historial incluso si el producto original se elimina.

### Funcionamiento

El trigger utiliza la tabla especial `deleted` de SQL Server para recuperar los valores anteriores de los registros afectados.

Mediante la tabla especial `inserted`, distingue las modificaciones (`UPDATE`) de las eliminaciones (`DELETE`). Luego, guarda los valores anteriores en `Auditoria_Producto`, junto con la fecha, la hora y el usuario de la base de datos.

### Pruebas realizadas

Se realizó una modificación temporal de la descripción del producto Potus, identificado con el número 1. La consulta de auditoría mostró los valores anteriores del producto, la operación `UPDATE`, la fecha y hora, y el usuario de la base de datos.

Posteriormente, se probó la eliminación temporal de un producto de prueba, identificado con el número 999. El resultado mostró que se conservaron sus datos anteriores y que la operación quedó identificada como `DELETE`.

Ambas pruebas se realizaron dentro de transacciones con `ROLLBACK`, por lo que los cambios y los registros de auditoría generados durante ellas se deshicieron al finalizar.

## 6. Trigger que impide eliminar categorías

**Nombre:** `TR_bloquear_delete_categoria`
**Tabla asociada:** `Categoria`
**Operación:** `DELETE`.

### Objetivo

Impedir la eliminación de registros de la tabla `Categoria` y comunicar al usuario que dicha operación no está permitida.

### Funcionamiento

El trigger se definió como `INSTEAD OF DELETE`, por lo que se ejecuta en lugar de la eliminación solicitada.

Cuando se intenta eliminar una categoría, el trigger utiliza la instrucción `THROW` para generar un mensaje de error. Como no ejecuta la eliminación original, el registro permanece en la tabla.

### Pruebas realizadas

Se intentó eliminar la categoría identificada con el número 8, correspondiente a Riego.

El trigger mostró el mensaje de error definido y la consulta posterior confirmó que la categoría seguía existiendo en la base de datos.

De esta manera, se verificó que el trigger impide la eliminación de registros de `Categoria`.

## 7. Conclusiones

A partir de las pruebas realizadas, se comprobó el funcionamiento de los cinco triggers implementados en la base de datos `VERDE_ENCANTO`.

Los tres triggers relacionados con el stock permitieron automatizar las variaciones de las existencias ocasionadas por ventas, compras y mermas. Además, se verificó que controlaran las operaciones para evitar que el stock quedara en valores negativos.

El trigger de auditoría permitió conservar temporalmente, durante las pruebas, los valores anteriores de los productos afectados por modificaciones y eliminaciones, junto con la fecha, la hora y el usuario de la base de datos. Esto demuestra cómo la auditoría puede facilitar el seguimiento de las operaciones realizadas.

Las pruebas de los triggers de stock y auditoría se realizaron mediante transacciones con `ROLLBACK`, lo que permitió verificar sus comportamientos sin dejar modificaciones permanentes en los datos originales.

Por su parte, el trigger asociado a `Categoria` impidió la eliminación de registros y mostró un mensaje de error cuando se intentó ejecutar la operación, se comprobó que la categoría permaneciera en la tabla después del intento de eliminación.

En conclusión, los triggers implementados contribuyen a mejorar la integridad, la consistencia y el control de los datos del sistema comercial del vivero, automatizando tareas y restringiendo operaciones que podrían afectar el correcto funcionamiento de la base de datos.
