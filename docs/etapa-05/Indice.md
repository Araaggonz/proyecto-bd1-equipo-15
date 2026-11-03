# Documentación de Optimización de Consultas mediante Índices - Etapa V

## 1. Introducción

En la base de datos `VERDE_ENCANTO` se desarrolló una prueba de optimización de consultas mediante índices, con el objetivo de analizar cómo influye su utilización en el rendimiento y los tiempos de recuperación de información.

Para realizar las pruebas se creó una tabla independiente llamada `VentaHistorica`, evitando modificar la tabla `Venta` original del sistema.

Los elementos desarrollados son:

* La creación de una tabla de pruebas con un millón de registros.
* Una consulta inicial sin índices.
* La creación de un índice agrupado sobre la fecha de venta.
* La creación de un índice no agrupado con cobertura.
* Mediciones de rendimiento y espacio de almacenamiento.

## 2. Creación y carga de datos

**Tabla:** `VentaHistorica`  
**Cantidad de registros:** 1.000.000  
**Columnas:** `id_venta`, `fecha_venta` e `importe`.

### Objetivo

Crear una tabla independiente que permita realizar pruebas de rendimiento sin modificar los datos reales del sistema.

### Funcionamiento

La tabla se crea sin clave primaria ni índices, por lo que inicialmente funciona como una tabla *Heap*.

Para cargar los registros se utiliza una CTE llamada `Numeros`, que genera un millón de valores. Posteriormente, se utiliza `INSERT` junto con funciones como `NEWID()`, `CHECKSUM()` y `DATEADD()` para generar fechas e importes aleatorios.

## 3. Consulta sin índices (escenario 1)

**Tabla:** `VentaHistorica`  
**Estructura:** Heap.

### Objetivo

Establecer un escenario inicial que permita comparar el rendimiento de una consulta sin índices frente a las siguientes implementaciones.

### Funcionamiento

Se ejecuta una consulta que obtiene las ventas realizadas durante el primer trimestre de 2023.

Al no existir índices, SQL Server debe recorrer los registros de la tabla para encontrar aquellos que cumplen con la condición. Por este motivo, se espera una operación `Table Scan` en el plan de ejecución.

Para medir el rendimiento se utilizan:

* `SET STATISTICS TIME ON`: muestra los tiempos de ejecución y de CPU.
* `SET STATISTICS IO ON`: muestra las lecturas realizadas sobre la tabla.
* `sp_spaceused`: permite consultar el espacio ocupado.

## 4. Índice agrupado sobre la fecha (escenario 2)

**Nombre:** `IX_VentaHistorica_Fecha`  
**Tipo:** Clustered Index.  
**Columna:** `fecha_venta`.

### Objetivo

Mejorar las búsquedas que utilizan la fecha de venta como condición, evitando recorrer toda la tabla cuando sea posible.

### Funcionamiento

Se crea un índice agrupado sobre `fecha_venta`. Este tipo de índice determina el orden físico de almacenamiento de los registros según la columna seleccionada.

Luego se ejecuta nuevamente la consulta del escenario anterior. Se espera que SQL Server utilice una operación `Clustered Index Seek`, permitiendo localizar directamente el rango de fechas solicitado.

Finalmente, se vuelven a registrar las mediciones de rendimiento y espacio ocupado.

## 5. Eliminación del índice agrupado

### Objetivo

Restablecer las condiciones iniciales de la tabla antes de realizar la siguiente prueba.

### Funcionamiento

Se utiliza `DROP INDEX` para eliminar el índice agrupado creado anteriormente. De esta manera, la tabla vuelve a funcionar como un Heap y se puede probar el siguiente tipo de índice de manera independiente.

## 6. Índice no agrupado con cobertura (escenario 3)

**Nombre:** `IX_VentaHistorica_Fecha_Cobertura`  
**Tipo:** Nonclustered Index.  
**Columna clave:** `fecha_venta`.  
**Columna incluida:** `importe`.

### Objetivo

Comprobar las ventajas de utilizar un índice con cobertura, permitiendo resolver consultas directamente desde el índice sin necesidad de acceder nuevamente a la tabla principal.

### Funcionamiento

Se crea un índice no agrupado sobre `fecha_venta`, incorporando también la columna `importe` mediante `INCLUDE`.

Posteriormente, se ejecuta una consulta que recupera ambas columnas para el primer trimestre de 2023.

Como toda la información solicitada se encuentra dentro del índice, SQL Server puede resolver la consulta utilizando su propia estructura. Se espera una operación `Index Seek`.

## 7. Consulta de agregación y análisis de almacenamiento

### Objetivo

Demostrar una aplicación práctica del índice de cobertura y analizar el espacio adicional que ocupan los índices.

### Funcionamiento

Se ejecuta una consulta que utiliza `COUNT(*)` para contar las ventas y `SUM(importe)` para calcular el total vendido durante el primer trimestre de 2023.

Además, se realiza una consulta sobre `sys.indexes` y `sys.dm_db_partition_stats` para obtener información sobre el espacio utilizado por cada índice.

Esto permite observar que, aunque los índices mejoran el rendimiento de las consultas, también requieren espacio adicional y mantenimiento.

## 8. Resumen de escenarios

| Escenario | Estructura | Operación esperada |
|---|---|---|
| 1 | Sin índices (Heap) | Table Scan |
| 2 | Índice agrupado | Clustered Index Seek |
| 3 | Índice no agrupado con cobertura | Index Seek |

Los resultados se comparan mediante los tiempos de ejecución, las lecturas lógicas, los planes de ejecución y el espacio ocupado.

## 9. Conclusiones

A partir de las pruebas realizadas, se pudo observar cómo influye la utilización de índices en el rendimiento de las consultas de SQL Server.

El escenario inicial permitió establecer una referencia sin índices. Luego, el índice agrupado permitió organizar los registros según la fecha de venta, mientras que el índice no agrupado con cobertura permitió recuperar la información directamente desde su estructura.

También se comprobó que los índices tienen un costo asociado, ya que ocupan espacio adicional y requieren mantenimiento cuando se modifican los datos.

En conclusión, una correcta utilización de índices permite optimizar las consultas y mejorar el acceso a grandes volúmenes de información, siempre teniendo en cuenta el equilibrio entre rendimiento y almacenamiento.
