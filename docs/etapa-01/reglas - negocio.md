# Reglas de negocio y requerimientos asociados

## Reglas de negocio explícitas

### RN.01 – Productos

El sistema debe permitir registrar y gestionar los productos comercializados por el vivero.

Cada producto debe:

* Poseer un identificador único.
* Pertenecer a una categoría.
* Contar con un precio de venta vigente.
* Contar con una cantidad de stock disponible.

### RN.02 – Clientes

El sistema debe permitir registrar y gestionar los clientes.

Cada cliente debe:

* Poseer un identificador único.
* Contar con sus datos básicos.

Además:

* Un cliente puede realizar múltiples compras.
* Cada compra pertenece a un único cliente.

### RN.03 – Gestión de stock

El sistema debe gestionar el stock disponible de cada producto, garantizando que no pueda ser negativo.

Al realizar una venta:

* El stock debe reducirse según las cantidades vendidas.
* No se debe permitir una venta que supere las existencias disponibles.

### RN.04 – Abastecimiento

El sistema debe permitir registrar las compras realizadas a proveedores.

Toda compra debe:

* Estar asociada a un proveedor registrado.
* Al confirmarse la recepción, incrementar las cantidades correspondientes en el stock.

### RN.05 – Precio histórico

El sistema debe conservar el precio unitario utilizado en cada venta.

El detalle de cada venta debe registrar el precio vigente al momento de la operación, evitando que modificaciones posteriores del precio alteren el historial.

### RN.06 – Venta y detalle

El sistema debe permitir registrar las ventas y sus respectivos detalles.

Toda venta debe:

* Contener una cabecera.
* Contener al menos un producto.

El subtotal de cada ítem se obtiene mediante:

> **Subtotal = Cantidad vendida × Precio unitario histórico**

El total de la venta corresponde a la suma de los subtotales.

### RN.07 – Métodos de pago

El sistema debe permitir registrar el método de pago utilizado en cada venta.

Cada venta debe registrar un único método de pago.

### RN.08 – Stock mínimo
El sistema debe permitir establecer un nivel de stock mínimo para cada producto. Cuando las existencias alcancen o queden por debajo de dicho límite, el producto debe identificarse para su reposición.

### RN.09 – Mermas 
El sistema debe permitir registrar las pérdidas de productos ocasionadas por marchitamiento, plagas o daños. Cada Universidad Nacional del Nordeste Facultad de Ciencias Exactas y Naturales y Agrimensura merma debe indicar fecha, cantidad y motivo, y debe descontarse del stock sin asociarse a una venta. 

### RN.10 – Comprobantes 
El sistema debe permitir conservar los comprobantes de venta y su información histórica. Los comprobantes no deben eliminarse físicamente y, en caso de cancelación o devolución autorizada, deben conservarse y pasar a un estado de anulación. 

## Reglas de negocio Implícitas

### RN.11 – Integridad histórica
Los clientes, productos y proveedores que posean operaciones históricas no deben eliminarse físicamente, sino mantenerse mediante un estado activo/inactivo.

### RN.12 – Integridad del stock
El stock disponible de cada producto debe mantenerse consistente con los movimientos de entrada y salida registrados en el sistema.

### RN.13 – Conservación histórica
La información asociada a operaciones ya realizadas debe conservarse sin modificaciones que alteren los datos históricos de dichas operaciones. 
Los métodos de pago permitidos son:

* Efectivo.
* Tarjeta de débito.
* Tarjeta de crédito.
* Transferencia bancaria.
