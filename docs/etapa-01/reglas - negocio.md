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

Los métodos de pago permitidos son:

* Efectivo.
* Tarjeta de débito.
* Tarjeta de crédito.
* Transferencia bancaria.
