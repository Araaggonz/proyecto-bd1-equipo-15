# Normalización — Verde Encanto

Este documento describe, paso a paso, el proceso de normalización aplicado al modelo de datos del sistema, partiendo de una estructura sin normalizar y llegando a las tablas en Tercera Forma Normal (3FN) que se definen en `modelo-relacional.md`.

## 0. Punto de partida (sin normalizar)

Si se registrara la información de una venta tal como figura en un comprobante del vivero, se obtendría una única estructura con un grupo repetitivo (el detalle de todos los productos comprados, anidado dentro de la misma venta):

```
Venta_Comprobante (
  Id_Venta, Fecha, DNI_Cliente, Nombre_Cliente, Telefono_Cliente,
  DNI_Vendedor, Nombre_Vendedor, Tipo_Metodo_Pago, Total,
  { Id_Producto, Nombre_Producto, Nombre_Categoria, Precio_Unitario, Cantidad }
)
```

**Problema:** el atributo entre llaves es un grupo repetitivo — una venta puede incluir varios productos (ej.: plantas + sustrato + una pala en la misma operación). Esto viola la atomicidad exigida por 1FN.

## 1. Primera Forma Normal (1FN)

**Regla:** eliminación de grupos repetitivos y garantía de atomicidad.

- Se elimina el grupo repetitivo de productos: un renglón por cada producto vendido dentro de una venta, en lugar de un renglón por venta.
- Todos los atributos pasan a ser atómicos.
- La clave primaria pasa a ser compuesta: `(Id_Venta, Id_Producto)`.

```
Venta_Detalle (
  Id_Venta (PK), Id_Producto (PK), Fecha, DNI_Cliente, Nombre_Cliente,
  Telefono_Cliente, DNI_Vendedor, Nombre_Vendedor, Tipo_Metodo_Pago,
  Nombre_Producto, Nombre_Categoria, Precio_Unitario, Cantidad, Total
)
```

Cumple 1FN, pero conserva redundancia: los datos de la venta se repiten por cada producto, y los datos del producto se repiten en cada venta en la que participa.

## 2. Segunda Forma Normal (2FN)

**Regla:** eliminación de dependencias funcionales parciales respecto de la clave compuesta `(Id_Venta, Id_Producto)`.

| Atributo | Depende de | Tipo de dependencia |
|---|---|---|
| Fecha, DNI_Cliente, Nombre_Cliente, Telefono_Cliente, DNI_Vendedor, Nombre_Vendedor, Tipo_Metodo_Pago, Total | Id_Venta | Parcial |
| Nombre_Producto, Nombre_Categoria | Id_Producto | Parcial |
| Precio_Unitario, Cantidad | Id_Venta + Id_Producto | Completa |

Los atributos con dependencia parcial migran a tablas separadas:

```
Venta (Id_Venta (PK), Fecha, DNI_Cliente (FK), Nombre_Cliente, Telefono_Cliente,
       DNI_Vendedor (FK), Nombre_Vendedor, Tipo_Metodo_Pago, Total)

Producto (Id_Producto (PK), Nombre_Producto, Nombre_Categoria)

Producto_Venta (Id_Venta (PK, FK), Id_Producto (PK, FK), Precio_Unitario, Cantidad)
```

Se elimina la redundancia de repetir datos de la venta por producto y del producto por venta. Quedan, sin embargo, dependencias transitivas dentro de Venta y Producto.

## 3. Tercera Forma Normal (3FN)

**Regla:** eliminación de dependencias transitivas (atributos no clave que dependen de otro atributo no clave, en vez de depender directamente de la clave primaria).

| Tabla origen | Dependencia transitiva detectada | Acción |
|---|---|---|
| Venta | Nombre_Cliente y Telefono_Cliente dependen de DNI_Cliente, no de Id_Venta | Se extraen a Persona / Cliente |
| Venta | Nombre_Vendedor depende de DNI_Vendedor, no de Id_Venta | Se extraen a Persona / Vendedor |
| Venta | Tipo_Metodo_Pago depende del método de pago, no de Id_Venta | Se extrae a Metodo_Pago (Id_Metodo, Tipo_Metodo) |
| Producto | Nombre_Categoria depende de la categoría, no de Id_Producto | Se extrae a Categoria (Id_Categoria, Nombre, Descripcion) |

Adicionalmente, dado que Cliente, Vendedor y Proveedor comparten los mismos datos personales (DNI, nombre, apellido, teléfono, correo), se aplica una generalización: se crea la entidad **Persona** con esos atributos comunes, y Cliente/Vendedor/Proveedor quedan como subtipos de rol (ver justificación completa en `decisiones-diseno.md`, sección "Generalización de Persona").

### Resultado final (3FN)

```
Persona         (DNI (PK), Nombre, Apellido, Telefono (U), Correo_Electronico (U))
Cliente         (DNI (PK, FK -> Persona), Id_Cliente (U))
Vendedor        (DNI (PK, FK -> Persona), Id_Vendedor (U))
Proveedor       (DNI (PK, FK -> Persona), Id_Proveedor (U), Direccion)
Categoria       (Id_Categoria (PK), Nombre, Descripcion)
Producto        (Id_Producto (PK), Nombre, Descripcion, Estado, Stock_Actual, Stock_Minimo, Precio_Venta, Id_Categoria (FK))
Metodo_Pago     (Id_Metodo (PK), Tipo_Metodo)
Venta           (Id_Venta (PK), Fecha, Total, DNI (FK -> Cliente), DNI (FK -> Vendedor), Id_Metodo (FK))
Producto_Venta  (Id_Venta (PK, FK), Id_Producto (PK, FK), Precio_Unitario, Cantidad, SubTotal)
Comprobante     (Id_Comprobante (PK), Numero, Fecha, Estado, Id_Venta (FK, U))
Compra          (Id_Compra (PK), Fecha, Total, DNI (FK -> Proveedor), DNI (FK -> Vendedor))
Producto_Compra (Id_Compra (PK, FK), Id_Producto (PK, FK), Precio_Unitario, Cantidad)
Merma           (Id_Merma (PK), Fecha, Motivo, Cantidad, Id_Producto (FK))
```

**Comprobante** y **Merma** son entidades nuevas incorporadas tras la revisión del DER; no surgen de dependencias parciales o transitivas dentro de otra tabla (no vienen de "romper" una tabla existente), sino que representan hechos propios del negocio que no estaban modelados: la emisión/anulación de un comprobante (RN.10) y el registro de pérdidas de stock (RN.09). Por eso se agregan directamente en 3FN, ya que sus atributos dependen únicamente de su propia clave primaria (`Id_Comprobante` e `Id_Merma`, respectivamente) y no presentan dependencias parciales ni transitivas.

`SubTotal` en `Producto_Venta` es un atributo derivado (`Cantidad × Precio_Unitario`, según RN.06); si el equipo decide calcularlo siempre al momento de la consulta en vez de almacenarlo, se puede quitar de este esquema sin afectar la normalización.

Ningún atributo no clave depende de una parte de una clave compuesta (2FN) ni de otro atributo no clave (3FN). El modelo coincide con la versión revisada de `modelo-relacional.md`, que incorpora Comprobante y Merma.

## Conclusión

La normalización evita anomalías de inserción, actualización y borrado, y sostiene los requerimientos de trazabilidad e historial de precios de las reglas de negocio RN.05, RN.11 y RN.13.
