# Procedimientos almacenados y funciones

## 1. Introducción

En esta etapa del proyecto **VERDE_ENCANTO**, se implementaron procedimientos almacenados y funciones en SQL Server para facilitar la administración de los productos y reutilizar operaciones habituales del sistema de gestión comercial del vivero.

Los procedimientos almacenados permiten ejecutar operaciones de inserción, modificación y eliminación de productos mediante parámetros. Por otro lado, las funciones permiten realizar cálculos relacionados con las ventas y consultar productos cuyo stock se encuentra por debajo del mínimo establecido.

Además, se realizaron pruebas de funcionamiento y comparaciones entre operaciones directas y alternativas basadas en procedimientos almacenados y funciones, utilizando `SET STATISTICS TIME ON` para observar los tiempos de ejecución.

## 2. Procedimientos almacenados

Se desarrollaron tres procedimientos almacenados para realizar las operaciones básicas de mantenimiento de la tabla `Producto`.

### 2.1. sp_InsertarProducto

Este procedimiento permite registrar un nuevo producto en la base de datos.

Recibe como parámetros los siguientes datos:

* `@id_producto`: identificador del producto.
* `@stock_actual`: cantidad de unidades disponibles.
* `@descripcion`: descripción del producto.
* `@nombre`: nombre del producto.
* `@stock_minimo`: cantidad mínima de unidades que se desea mantener en stock.
* `@estado`: estado del producto, que puede ser `ACTIVO` o `INACTIVO`.
* `@id_categoria`: identificador de la categoría a la que pertenece.

Los valores recibidos se utilizan para realizar una sentencia `INSERT` en la tabla `Producto`.

**Objetivo:** centralizar la inserción de productos y evitar tener que escribir toda la sentencia de inserción cada vez que se necesita registrar uno nuevo.

### 2.2. sp_ModificarProducto

Este procedimiento permite modificar determinados datos de un producto existente.

Recibe el identificador del producto y los nuevos valores para su nombre, descripción, stock mínimo y estado.

Mediante una sentencia `UPDATE`, actualiza las columnas correspondientes del registro cuyo identificador coincide con el parámetro recibido.

También verifica si la operación modificó alguna fila. Si el producto no existe, genera un error informativo mediante `THROW`.

**Objetivo:** facilitar la actualización de los datos de un producto y comunicar cuando se intenta modificar un registro inexistente.

### 2.3. sp_EliminarProducto

Este procedimiento permite eliminar un producto de la tabla `Producto` a partir de su identificador.

Utiliza una sentencia `DELETE` para eliminar el registro correspondiente. Si no se encuentra ningún producto con ese identificador, genera un error informativo mediante `THROW`.

**Objetivo:** centralizar la eliminación de productos y detectar cuando el identificador indicado no corresponde a un registro existente.

La eliminación continúa sujeta a las restricciones de integridad referencial de la base de datos. Por lo tanto, un producto relacionado con registros de otras tablas puede no poder eliminarse mientras existan esas referencias.

## 3. Funciones

Se desarrollaron tres funciones para reutilizar cálculos y consultas relacionados con las ventas y el control de stock.

### 3.1. fn_CalcularSubtotal

Esta función calcula el subtotal de una operación a partir del precio unitario y la cantidad de unidades.

Recibe dos parámetros:

* `@precio_unitario`: precio de una unidad.
* `@cantidad`: cantidad de unidades.

Multiplica ambos valores y devuelve el resultado como un valor decimal.

**Ejemplo de prueba:**

```sql
SELECT dbo.fn_CalcularSubtotal(1800, 2) AS subtotal;
```

**Resultado esperado:** `3600.00`.

La función permite reutilizar el cálculo del subtotal sin tener que escribir nuevamente la multiplicación en cada consulta.

### 3.2. fn_CalcularTotalVenta

Esta función calcula el total de una venta a partir de los subtotales registrados en la tabla `Producto_Venta`.

Recibe el identificador de la venta y suma los valores de la columna `sub_total` correspondientes a sus detalles.

Utiliza `SUM` para calcular el importe acumulado y `COALESCE` para devolver cero cuando no existen detalles para esa venta.

**Ejemplo de prueba:**

```sql
SELECT dbo.fn_CalcularTotalVenta(8) AS total_venta;
```

**Resultado obtenido:** `3600.00`.

El resultado coincidió con el importe de los detalles de la venta número 8.

Esta función permite consultar el total calculado a partir de los detalles registrados. No modifica automáticamente la columna `total` de la tabla `Venta`.

### 3.3. fn_ProductosBajoStock

Esta función devuelve una tabla con los productos cuyo stock actual es inferior al stock mínimo establecido.

Incluye las siguientes columnas:

* `id_producto`.
* `nombre`.
* `stock_actual`.
* `stock_minimo`.

La condición utilizada para identificar los productos que necesitan reposición es:

```sql
stock_actual < stock_minimo
```

**Ejemplo de prueba:**

```sql
SELECT *
FROM dbo.fn_ProductosBajoStock();
```

Durante las pruebas, la función devolvió cero filas. Esto significa que, en ese momento, ningún producto cumplía la condición establecida.

La ausencia de resultados no representa un error: indica que no se encontraron productos por debajo de su stock mínimo.

**Objetivo:** facilitar la identificación de productos que podrían necesitar reposición y contribuir al control del inventario.

## 4. Pruebas de funcionamiento

Para comprobar el funcionamiento de los procedimientos almacenados, se utilizaron registros de prueba con identificadores específicos.

Se realizaron las siguientes operaciones:

| Modalidad                  | Inserción                         | Modificación          | Eliminación           |
| -------------------------- | --------------------------------- | --------------------- | --------------------- |
| Operaciones SQL directas   | Producto 9003 y producto 9004     | Producto 9003         | Producto 9004         |
| Procedimientos almacenados | Productos 9001, 9002, 9005 y 9006 | Productos 9001 y 9005 | Productos 9002 y 9006 |

Las pruebas permitieron verificar que los procedimientos podían insertar, modificar y eliminar productos según los parámetros recibidos.

También se comprobaron las tres funciones mediante consultas `SELECT`, verificando los resultados del cálculo de subtotales, el total de una venta y la búsqueda de productos por debajo del stock mínimo.

Los productos utilizados en las pruebas fueron registros de prueba y no productos comerciales reales del vivero.

## 5. Comparación de eficiencia

Se compararon operaciones directas con procedimientos almacenados y funciones equivalentes, utilizando la instrucción `SET STATISTICS TIME ON` para observar los tiempos de compilación y ejecución informados por SQL Server.

### 5.1. Modificación de productos

Se comparó una sentencia `UPDATE` directa con la ejecución del procedimiento `sp_ModificarProducto`.

En una de las mediciones se observaron aproximadamente 7 ms en un bloque de ejecución directa y 4 ms en un bloque que invocaba el procedimiento almacenado.

Estos valores son orientativos. La salida incluye distintos pasos internos de SQL Server y una sola medición no permite concluir que el procedimiento almacenado sea más rápido.

### 5.2. Cálculo del subtotal

Se comparó la función `fn_CalcularSubtotal` con una multiplicación directa.

Ambas alternativas devolvieron el mismo resultado: `3600.00`. En las dos pruebas se registró un tiempo de ejecución de `0 ms`.

Por lo tanto, no se observó una diferencia medible de tiempo en esta prueba.

### 5.3. Consulta de productos con stock bajo

Se comparó la función `fn_ProductosBajoStock` con una consulta directa que aplicaba la misma condición sobre la tabla `Producto`.

Ambas consultas devolvieron cero filas y registraron un tiempo de ejecución de `0 ms`.

Dado el tamaño reducido de la tabla y la ausencia de resultados, no fue posible identificar una diferencia de rendimiento significativa.

### 5.4. Conclusión de la comparación

Las pruebas permitieron comprobar que los procedimientos almacenados y las funciones producen los resultados esperados. Sin embargo, no se obtuvieron evidencias suficientes para afirmar que estas alternativas sean más rápidas que las operaciones directas.

Los procedimientos almacenados ofrecen ventajas de organización, reutilización y centralización de operaciones. Las funciones, por su parte, permiten reutilizar cálculos y consultas desde otras sentencias SQL.

Los tiempos registrados de `0 ms` indican que la duración fue demasiado pequeña para reflejarse en la precisión de la medición presentada; no significan que las operaciones no hayan consumido recursos. 

## 6. Conclusión general

La implementación de procedimientos almacenados y funciones amplió las posibilidades de administración y consulta de la base de datos `VERDE_ENCANTO`.

Los tres procedimientos almacenados permiten realizar las operaciones básicas de inserción, modificación y eliminación de productos. Las tres funciones permiten calcular subtotales, obtener el total de una venta a partir de sus detalles e identificar productos cuyo stock se encuentra por debajo del mínimo establecido.

Las pruebas realizadas permitieron verificar el funcionamiento de los objetos creados y comparar sus resultados con operaciones SQL directas.

En conclusión, estos recursos contribuyen a organizar el código SQL y reutilizar operaciones dentro del sistema de gestión comercial del vivero, aunque las pruebas realizadas no permiten determinar una ventaja significativa de rendimiento frente a las alternativas directas.