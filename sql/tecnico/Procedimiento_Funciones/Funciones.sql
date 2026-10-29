
---creacion de funciones almacenadas

CREATE OR ALTER FUNCTION dbo.fn_CalcularSubtotal
(
    @precio_unitario DECIMAL(10,2),
    @cantidad INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @precio_unitario * @cantidad;
END;



---VERIFICAR
SELECT dbo.fn_CalcularSubtotal(1800, 2) AS subtotal;


---FUNCION QUE CALCULA EL TOTAL DE UNA VENTA

CREATE OR ALTER FUNCTION dbo.fn_CalcularTotalVenta
(
    @id_venta INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = COALESCE(SUM(sub_total), 0)
    FROM Producto_Venta
    WHERE id_venta = @id_venta;

    RETURN @total;
END;


---VERIFICAR
SELECT dbo.fn_CalcularTotalVenta(8) AS total_calculado;


---FUNCION QUE DEVUELVE PRODUCTOS CON STOCK MENOR AL MINIMO

CREATE OR ALTER FUNCTION dbo.fn_ProductosBajoStock()
RETURNS TABLE
AS
RETURN
(
    SELECT
        id_producto,
        nombre,
        stock_actual,
        stock_minimo
    FROM Producto
    WHERE stock_actual < stock_minimo
);


---VERIFICAR
SELECT *
FROM dbo.fn_ProductosBajoStock();


---verificar que ningún producto esta por debajo de su stock_minimo 
SELECT
    id_producto,
    nombre,
    stock_actual,
    stock_minimo
FROM Producto
ORDER BY id_producto;

