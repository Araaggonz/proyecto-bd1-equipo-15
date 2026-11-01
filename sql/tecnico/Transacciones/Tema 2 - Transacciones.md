# Etapa V: Implementación de Temas Técnicos
## Tema 2: Manejo de Transacciones y Transacciones Anidadas

**Proyecto:** Sistema de Gestión Comercial -- Vivero **Verde Encanto**  
**Equipo:** 15  
**Integrante:** Belén Chaile  

---

## 1. Introducción y Objetivos

En esta sección se presenta la implementación de **transacciones y transacciones anidadas** en **SQL Server Express**, aplicada a la base de datos `VERDE_ENCANTO`.

El objetivo es comprobar que las operaciones relacionadas con el registro de ventas y la actualización del stock se confirmen en conjunto cuando resultan exitosas o se reviertan cuando ocurre un error, preservando la consistencia de los datos.

---

## 2. Manejo de Transacciones

Una transacción agrupa varias operaciones SQL en una unidad de trabajo. Para su control se utilizaron:

- **`BEGIN TRANSACTION`**: inicia una transacción.
- **`COMMIT TRANSACTION`**: confirma los cambios realizados.
- **`ROLLBACK TRANSACTION`**: revierte los cambios no confirmados.
- **`TRY...CATCH`**: permite controlar errores durante la ejecución.
- **`THROW`**: genera un error para activar el tratamiento correspondiente.
- **`@@TRANCOUNT`**: permite comprobar los niveles de transacción activos.

### 2.1. Ensayo con reversión voluntaria

Se simula el registro de una venta, incluyendo comprobante, venta, detalle y descuento de stock. Antes de finalizar, se ejecuta `ROLLBACK TRANSACTION` para revertir voluntariamente las modificaciones.

```sql
BEGIN TRANSACTION;
-- Registro de comprobante, venta y detalle.
-- Actualización del stock.
ROLLBACK TRANSACTION;
```

### 2.2. Transacción exitosa con COMMIT

Se registra la **venta 9**, junto con su comprobante y detalle, y se actualiza el stock del producto asociado.

```sql
BEGIN TRANSACTION;
-- Inserciones y actualización del stock.
COMMIT TRANSACTION;
```

La operación confirmó una venta por **$7.500**, correspondiente a **3 unidades de $2.500**, y el stock del producto **Potus** pasó de **25 a 22 unidades**.

### 2.3. Error intencional y ROLLBACK

Se realizan inserciones de comprobante y venta, además de una actualización de stock. Luego se genera un error controlado para comprobar que las operaciones se revierten.

```sql
THROW 50001, 'ERROR INTENCIONAL: prueba de ROLLBACK.', 1;
```

El bloque `CATCH` ejecuta `ROLLBACK TRANSACTION` si existe una transacción abierta. Tras la prueba, no quedaron registros de la venta ni del comprobante 10, y el stock permaneció en **22 unidades**.

---

## 3. Transacciones Anidadas

Se utilizaron dos instrucciones `BEGIN TRANSACTION`: una externa y otra interna. La transacción interna modificó nuevamente el stock y ejecutó `COMMIT`, pero la transacción externa finalizó con `ROLLBACK`.

```sql
BEGIN TRANSACTION; -- Transacción externa
    -- Primera actualización de stock
    BEGIN TRANSACTION; -- Transacción interna
        -- Segunda actualización de stock
    COMMIT TRANSACTION;
ROLLBACK TRANSACTION;
```

El stock pasó temporalmente de **22 a 19 unidades**. Después del `ROLLBACK` externo, recuperó el valor **22**. Esto demuestra que un `COMMIT` interno no confirma definitivamente las modificaciones mientras la transacción externa permanezca abierta.

---

## 4. Archivos y Evidencias

- **[`Transacciones.sql`](Transacciones.sql)**: script con las operaciones y pruebas realizadas.
- **`Evidencias/`**: carpeta con ocho capturas de pantalla de las ejecuciones y verificaciones.
- **[Documentación detallada de transacciones](../../../docs/etapa-05/Transacciones.md)**: desarrollo completo de la implementación, resultados y conclusiones.

---

## 5. Instrucciones de Ejecución

1. Abrir `Transacciones.sql` en **SQL Server Management Studio (SSMS)**.
2. Seleccionar la base de datos `VERDE_ENCANTO`.
3. Revisar las condiciones iniciales y ejecutar las pruebas **por bloques**, según corresponda.
4. Consultar los resultados y verificar los cambios en las tablas involucradas.

**Importante:** la venta y el comprobante con identificador **9** ya fueron registrados durante la prueba exitosa. No se debe volver a ejecutar ese bloque sobre la misma base de datos sin preparar un entorno de prueba adecuado, ya que podrían producirse errores por identificadores duplicados.

---

## 6. Conclusión

Las pruebas permitieron comprobar el funcionamiento de `COMMIT` y `ROLLBACK` en el registro de ventas y la actualización de stock. También demostraron que una transacción externa puede revertir modificaciones efectuadas dentro de una transacción anidada, incluso después de un `COMMIT` interno.

La explicación detallada de cada prueba y sus evidencias se encuentra en la documentación principal de la Etapa V.
