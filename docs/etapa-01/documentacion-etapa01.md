# Alcance del proyecto

El alcance de nuestro proyecto será el de un sistema de gestión comercial que incluiría funcionalidades propias de un POS (Point Of Sale) para la gestión de operaciones realizadas en el punto de venta. De esta manera, el sistema permitirá desde administrar la información general del negocio, así como registrar y controlar las operaciones de compra y venta.

El sistema estará orientado a mantener la integridad, consistencia y trazabilidad de la información.

## Funcionalidades previstas como Point Of Sale

1. Registro de ventas y sus respectivos detalles.
2. Identificación del cliente en la operación.
3. Registro del método de pago.
4. Cálculo de subtotales y total de la venta.
5. Actualización del stock a partir de las ventas.
6. Generación y conservación del comprobante de venta.
# Funcionalidades del Sistema - Verde Encanto

Acá resumimos todo lo que va a poder hacer nuestro sistema para administrar y gestionar el vivero en el día a día.

---

## ¿Qué va a hacer el sistema?

* **Gestión de productos y categorías:** Para guardar y organizar todo lo que vendemos (plantas, macetas, herramientas, semillas, sustratos, etc.).
* **Gestión de proveedores:** Para tener a mano la información de las personas o empresas a las que les compramos los productos.
* **Compras y abastecimiento:** Para registrar cada vez que le compramos stock a un proveedor y mantener todo al día.
* **Control y actualización de stock:** Para saber exactamente cuánto stock nos queda de cada ítem en tiempo real.
* **Alertas de stock mínimo:** El sistema nos avisa cuando un producto se está por agotar para que sepamos qué volver a pedir.
* **Historial de precios:** Guarda los precios que tuvieron los productos en el pasado para no perder el registro de los cambios.
* **Registro de mermas (pérdidas):** Para dar de baja del stock las plantas o productos que se arruinen, marchiten o dañen sin asociarlos a una venta.
* **Historial y comprobantes:** Para guardar todos los registros y comprobantes anteriores sin borrar nada de forma definitiva.
* **Gestión de clientes:** Para guardar los datos de los clientes y conocer su historial con el vivero.

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
