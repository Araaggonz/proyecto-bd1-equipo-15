# Documentación del código SQL

## 1. Introducción

En esta etapa se realizó la implementación de la base de datos correspondiente al sistema de gestión comercial del vivero **Verde Encanto**.

A partir del modelo conceptual desarrollado en la etapa anterior, se construyó la estructura de la base de datos utilizando SQL Server.

El código SQL define la base de datos, las tablas, atributos, claves primarias, claves foráneas y restricciones necesarias para mantener la integridad y consistencia de la información.

## 2. Creación de la base de datos

La base de datos utilizada para el sistema se denomina `VERDE_ENCANTO`.

```sql
CREATE DATABASE VERDE_ENCANTO;
```

Esta base de datos contiene la información necesaria para gestionar personas, clientes, proveedores, vendedores, productos, categorías, compras, ventas, métodos de pago, comprobantes y mermas.

## 3. Tablas implementadas

La base de datos está compuesta por las siguientes tablas:

| Tabla             | Función                                                        |
| ----------------- | -------------------------------------------------------------- |
| `Persona`         | Almacena los datos generales de las personas.                  |
| `Proveedor`       | Registra los proveedores del vivero.                           |
| `Cliente`         | Registra los clientes del vivero.                              |
| `Vendedor`        | Registra los vendedores.                                       |
| `Metodo_Pago`     | Almacena los métodos de pago disponibles.                      |
| `Comprobante`     | Registra los comprobantes asociados a las ventas.              |
| `Venta`           | Registra las ventas realizadas.                                |
| `Categoria`       | Permite clasificar los productos.                              |
| `Producto`        | Almacena los productos y su información de stock.              |
| `Compra`          | Registra las compras realizadas.                               |
| `Producto_Venta`  | Contiene el detalle de los productos incluidos en cada venta.  |
| `Producto_Compra` | Contiene el detalle de los productos incluidos en cada compra. |
| `Merma`           | Registra las pérdidas o disminuciones de productos.            |

## 4. Claves primarias

Cada tabla posee una clave primaria (`PRIMARY KEY`) que permite identificar de manera única sus registros.

Por ejemplo, en `Persona` se utiliza:

```sql
CONSTRAINT PK_persona_dni PRIMARY KEY (DNI)
```

Mientras que en tablas como `Venta`, `Compra` y `Producto` se utilizan identificadores propios:

```text
Venta → id_venta
Compra → id_compra
Producto → id_producto
```

## 5. Claves foráneas

Las claves foráneas (`FOREIGN KEY`) permiten establecer las relaciones entre las tablas y garantizar que las referencias correspondan a registros existentes.

Entre las relaciones implementadas se encuentran:

* `Proveedor` → `Persona`
* `Cliente` → `Persona`
* `Vendedor` → `Persona`
* `Venta` → `Cliente`
* `Venta` → `Vendedor`
* `Venta` → `Metodo_Pago`
* `Venta` → `Comprobante`
* `Compra` → `Proveedor`
* `Compra` → `Vendedor`
* `Producto` → `Categoria`
* `Producto_Venta` → `Producto`
* `Producto_Venta` → `Venta`
* `Producto_Compra` → `Producto`
* `Producto_Compra` → `Compra`
* `Merma` → `Producto`

Por ejemplo, la tabla `Venta` posee las siguientes referencias:

```sql
CONSTRAINT FK_venta_metodo
FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo),

CONSTRAINT FK_venta_comprobante
FOREIGN KEY (id_comprobante) REFERENCES Comprobante(id_comprobante),

CONSTRAINT FK_venta_vendedor
FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor),

CONSTRAINT FK_venta_cliente
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
```

Esto permite asociar cada venta con el cliente, vendedor, método de pago y comprobante correspondientes.

## 6. Detalle de ventas y compras

Las operaciones de venta y compra utilizan tablas de detalle.

### `Producto_Venta`

Registra los productos incluidos en una venta y contiene:

* `id_producto`
* `id_venta`
* `precio_unitario`
* `cantidad`
* `sub_total`

El `precio_unitario` se almacena en el detalle para conservar el precio correspondiente a la operación realizada.

Además, se establece que la cantidad y el precio deben ser mayores que cero.

### `Producto_Compra`

Registra los productos incluidos en una compra y contiene:

* `id_producto`
* `id_compra`
* `precio_unitario`
* `cantidad`
* `subtotal_`

Al igual que en las ventas, el precio unitario queda registrado en el detalle de la compra.

Esto permite conservar el precio utilizado en cada operación.


## 7. Estados de los productos

El atributo `estado` de `Producto` posee una restricción que limita los valores permitidos:

```sql
CHECK (estado IN ('ACTIVO', 'INACTIVO'))
```

Por lo tanto, un producto solamente puede encontrarse en uno de los dos estados definidos.


## 8. Registro de mermas

La tabla `Merma` permite registrar pérdidas de productos.

Contiene información sobre:

* motivo;
* fecha;
* cantidad;
* producto afectado.

La relación con `Producto` se implementa mediante:

```sql
CONSTRAINT FK_merma_producto
FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
```

Esto permite identificar el producto al que corresponde cada merma.

## 9. Integridad de los datos

La implementación utiliza diferentes restricciones para mantener la integridad de la información:

* `PRIMARY KEY` para identificar registros de forma única.
* `FOREIGN KEY` para mantener las relaciones entre tablas.
* `NOT NULL` para establecer atributos obligatorios.
* `UNIQUE` para evitar valores duplicados.
* `CHECK` para limitar los valores permitidos.

Estas restricciones permiten implementar parte de las reglas del sistema directamente en la base de datos.
