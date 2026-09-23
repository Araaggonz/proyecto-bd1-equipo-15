# Decisiones de diseño — Verde Encanto

Este documento registra las decisiones de modelado que **no** quedan cubiertas por el proceso de normalización (`normalizacion.md`), pero que fueron necesarias para llegar al modelo relacional final. Para cada una se indica la decisión, la alternativa descartada y la razón.

## 1. Generalización de Persona

**Decisión:** crear una entidad `Persona` (DNI, Nombre, Apellido, Telefono, Correo_Electronico) de la cual `Cliente`, `Vendedor` y `Proveedor` heredan por rol, en vez de que cada una tenga sus propios atributos de nombre/contacto.

**Alternativa descartada:** tres tablas independientes (Cliente, Vendedor, Proveedor), cada una con Nombre, Apellido, Teléfono y Correo propios.

**Razón:** una misma persona (DNI) puede cumplir más de un rol en el negocio (por ejemplo, ser cliente y también trabajar como vendedor). Con tablas independientes, sus datos personales se duplicarían y podrían volverse inconsistentes si se actualiza en un rol y no en otro. Con Persona como tabla base, el dato se guarda una sola vez y cada rol solo agrega lo que le es propio (Id_Cliente, Id_Vendedor, Id_Proveedor + Dirección).

## 2. Tablas intermedias con clave compuesta (Producto_Venta y Producto_Compra)

**Decisión:** `Producto_Venta` y `Producto_Compra` usan como clave primaria la combinación de las dos claves foráneas (`Id_Venta + Id_Producto`, `Id_Compra + Id_Producto`), sin agregar un identificador propio.

**Alternativa descartada:** agregar un `Id_Detalle` autonumérico como clave primaria de cada tabla.

**Razón:** la relación entre Venta/Compra y Producto es N:M (una venta tiene varios productos, un producto aparece en varias ventas), y no puede repetirse el mismo producto dos veces dentro de la misma venta. La clave compuesta refleja esa regla de negocio directamente en el modelo (no se puede insertar dos veces el mismo par venta-producto), sin necesitar una restricción adicional.

## 3. Precio histórico en el detalle, no en Producto

**Decisión:** `Precio_Unitario` se guarda en `Producto_Venta` y `Producto_Compra`, y no se toma en el momento de la consulta desde `Producto`.

**Razón:** viene directo de **RN.05 — Precio histórico**: el precio vigente al momento de la operación debe quedar fijo en el detalle, para que un cambio posterior de precio en `Producto` no altere ventas o compras ya realizadas.

## 4. Stock centralizado en Producto

**Decisión:** `Stock_Actual` es un único atributo en la tabla `Producto`, actualizado por las operaciones de venta, compra y merma, en vez de calcularse siempre "al vuelo" sumando movimientos históricos.

**Razón:** RN.03 exige que el stock nunca sea negativo y se valide en cada venta; tenerlo como campo directo permite validar disponibilidad de forma inmediata. La consistencia de ese valor contra los movimientos registrados es lo que exige RN.12 (Integridad del stock).

## 5. DNI como clave primaria de Persona

**Decisión:** usar `DNI` como clave primaria de `Persona` (y, por lo tanto, como clave/FK compartida en Cliente, Vendedor y Proveedor), en vez de un `Id_Persona` autonumérico.

**Alternativa descartada:** `Id_Persona` autonumérico como PK, con DNI como atributo único (U).

**Razón:** el DNI ya es un identificador único y estable de la persona en la vida real, y evita mantener dos identificadores para lo mismo. Se eligió priorizar el identificador natural del dominio antes que uno artificial, dado que no se prevé que una persona cambie de DNI.

## 6. Atributos marcados como únicos (U)

**Decisión:** `Telefono` y `Correo_Electronico` en Persona, e `Id_Cliente`, `Id_Vendedor`, `Id_Proveedor` en sus respectivas tablas, se marcan como atributos únicos (no clave primaria, pero sin duplicados permitidos).

**Razón:** son identificadores secundarios útiles para búsquedas o para identificar a la persona por otro medio (por ejemplo, contactar a un cliente por teléfono o correo), pero no se usan como clave primaria porque el DNI ya cumple ese rol y estos datos podrían no estar disponibles para todas las personas al momento del alta.

## 7. Comprobante como entidad separada de Venta

**Decisión:** `Comprobante` (Id_Comprobante, Numero, Fecha, Estado) se modela como una entidad aparte de `Venta`, relacionada 1 a 1.

**Alternativa descartada:** agregar Numero y Estado como atributos directos de `Venta`.

**Razón:** RN.10 exige que el comprobante pueda pasar a un estado de anulación (por cancelación o devolución) sin que eso altere el historial de la venta en sí (RN.13). Si el estado de anulación viviera dentro de la tabla `Venta`, se estaría mezclando un dato que cambia (el estado del comprobante) con datos que deben permanecer fijos una vez registrada la venta (fecha, total, cliente). Separarlos evita esa mezcla.

## 8. Merma como entidad propia, no como un tipo de venta

**Decisión:** `Merma` (Id_Merma, Fecha, Motivo, Cantidad) se modela como una entidad independiente asociada a `Producto`, y no como una venta con cantidad negativa o un tipo especial de movimiento dentro de `Producto_Venta`.

**Razón:** RN.09 es explícita en que una merma "debe descontarse del stock sin asociarse a una venta". Una merma no tiene cliente, ni vendedor, ni método de pago, ni genera ingreso — mezclarla con Venta obligaría a tener atributos opcionales o casos especiales dentro de esa tabla. Modelarla aparte mantiene cada tabla representando un único concepto del negocio.

## 9. Baja lógica en lugar de eliminación física

**Decisión:** Persona, Producto y Proveedor no se eliminan físicamente cuando tienen operaciones históricas asociadas; se prevé un estado activo/inactivo.

**Razón:** cumple directamente con RN.11 (Integridad histórica) y RN.13 (Conservación histórica): si se borrara físicamente un cliente o producto con ventas ya registradas, esas ventas quedarían con una referencia rota o perderían información necesaria para el historial.
