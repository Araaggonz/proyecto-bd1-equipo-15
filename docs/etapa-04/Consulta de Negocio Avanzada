- ==========================================================
-- ¿Qué productos vendieron más de 10 unidades en septiembre 2026?
-- ==========================================================
SELECT p.nombre              AS producto,
       SUM(pv.cantidad)      AS unidades_vendidas,
       SUM(pv.sub_total)     AS monto_total
FROM Venta v
JOIN Producto_Venta pv ON pv.id_venta   = v.id_venta
JOIN Producto p        ON p.id_producto = pv.id_producto
WHERE v.fecha_ BETWEEN '2026-09-01' AND '2026-09-30'
GROUP BY p.nombre
HAVING SUM(pv.cantidad) > 10
ORDER BY unidades_vendidas DESC, monto_total DESC;
