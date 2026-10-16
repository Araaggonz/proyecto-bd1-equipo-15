
USE VERDE_ENCANTO;
GO

/*
==========================================================
Obtener el encabezado y detalle de cada venta,
mostrando el cliente, vendedor, comprobante,
metodo de pago y productos vendidos.

Se calcula:
- Subtotal de cada renglon (cantidad * precio).
- Total de cada venta mediante SUM() OVER().
- Diferencia entre el total calculado y el registrado.

La consulta no modifica datos de la base.
==========================================================
*/

SELECT
    -- Encabezado del comprobante
    c.numero AS numero_comprobante,
    c.fecha AS fecha_comprobante,
    c.estado_ AS estado_comprobante,
    v.id_venta,

    -- Datos del cliente
    pc.nombre AS nombre_cliente,
    pc.apellido AS apellido_cliente,

    -- Datos del vendedor
    pvend.nombre AS nombre_vendedor,
    pvend.apellido AS apellido_vendedor,

    -- Metodo de pago
    mp.tipo_metodo_ AS metodo_pago,

    -- Detalle de productos vendidos
    pr.nombre AS producto,
    pv.cantidad,
    pv.precio_unitario,

    -- Subtotal calculado por renglon
    pv.cantidad * pv.precio_unitario AS subtotal,

    -- Total calculado de cada venta
    SUM(pv.cantidad * pv.precio_unitario)
        OVER (PARTITION BY v.id_venta) AS total_calculado,

    -- Total registrado en la tabla Venta
    v.total AS total_registrado,

    -- Diferencia entre ambos totales
    v.total -
    SUM(pv.cantidad * pv.precio_unitario)
        OVER (PARTITION BY v.id_venta) AS diferencia_total

FROM Venta v

-- Relacion con el comprobante
INNER JOIN Comprobante c
    ON v.id_comprobante = c.id_comprobante

-- Relacion con el cliente
INNER JOIN Cliente cl
    ON v.id_cliente = cl.id_cliente

INNER JOIN Persona pc
    ON cl.DNI_cliente = pc.DNI

-- Relacion con el vendedor
INNER JOIN Vendedor vend
    ON v.id_vendedor = vend.id_vendedor

INNER JOIN Persona pvend
    ON vend.DNI_vendedor = pvend.DNI

-- Relacion con el metodo de pago
INNER JOIN Metodo_Pago mp
    ON v.id_metodo = mp.id_metodo

-- Relacion con el detalle de venta
INNER JOIN Producto_Venta pv
    ON v.id_venta = pv.id_venta

-- Relacion con los productos
INNER JOIN Producto pr
    ON pv.id_producto = pr.id_producto

-- Ordenar por comprobante y producto
ORDER BY c.numero, pr.nombre;
