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


### Claves primarias compuestas

Las tablas `Producto_Venta` y `Producto_Compra` representan el detalle de las operaciones y utilizan claves primarias compuestas.

En `Producto_Venta`:

```sql
CONSTRAINT PK_producto_venta PRIMARY KEY (id_producto, id_venta)
```

En `Producto_Compra`:

```sql
CONSTRAINT PK_producto_compra PRIMARY KEY (id_producto, id_compra)
```
La combinación de ambos identificadores permite identificar de manera única cada producto dentro de una determinada venta o compra.


## 10. Relaciones entre Persona, Cliente, Proveedor y Vendedor

La tabla `Persona` almacena los datos generales de las personas.

Las tablas `Cliente`, `Proveedor` y `Vendedor` poseen una referencia al `DNI` de `Persona`, permitiendo asociar una persona con el rol que desempeña dentro del sistema.

Por ejemplo:

```sql
CONSTRAINT FK_persona_cliente
FOREIGN KEY (DNI_cliente) REFERENCES Persona(DNI)
```

De esta manera, el sistema evita registrar un cliente asociado a una persona inexistente.

# 11. Gestión de productos y stock

La tabla `Producto` contiene información sobre los productos comercializados por el vivero.

Entre sus atributos se encuentran:

* `id_producto`
* `nombre`
* `descripcion`
* `stock_actual`
* `stock_minimo`
* `estado`
* `id_categoria`

El producto se relaciona con `Categoria` mediante `id_categoria`.

Además, se incorporaron restricciones para controlar los valores de stock:

```sql
CHECK (stock_actual >= 0)
```
y:

```sql
CHECK (stock_minimo >= 0)
```
Estas restricciones impiden registrar valores negativos.


## 12. Restricciones sobre cantidades y precios

Se establecieron restricciones `CHECK` para garantizar que las cantidades y precios sean válidos.

En las ventas:

```sql
CHECK (cantidad > 0)
```
y:

```sql
CHECK (precio_unitario > 0)
```

En las compras se aplican las mismas condiciones.

Para las mermas también se establece:

```sql
CHECK (cantidad > 0)
```
De esta forma, no se permiten cantidades iguales o menores que cero en estas operaciones.


## 13. Restricciones de unicidad

Se utilizaron restricciones `UNIQUE` para evitar valores duplicados.

En `Persona`, el teléfono y el correo electrónico deben ser únicos:

```sql
CONSTRAINT UQ_persona_telefono UNIQUE (telefono)

CONSTRAINT UQ_persona_correo UNIQUE (correo_electronico)
```

También se establece que el número de comprobante no puede repetirse:

```sql
CONSTRAINT UQ_comprobante_numero UNIQUE (numero)
```

## 14. Uso de NOT NULL

Los atributos definidos como `NOT NULL` son campos obligatorios.

Por ejemplo:

```sql
DNI VARCHAR(10) NOT NULL
```
Esto significa que no se puede crear un registro de `Persona` sin proporcionar un DNI.

El uso de `NOT NULL` permite reforzar desde la base de datos aquellos datos que son necesarios para el funcionamiento del sistema.

## 15. Código fuente

El código SQL ddl utilizado para la creación de la base de datos se encuentra en:

[`sql/DDL/script.sql`](../../SQL/ddl/script.sql) 
