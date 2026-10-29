


---SCRIPT DE INSERCION DIRECTA

INSERT INTO Producto (id_producto,stock_actual,descripcion,nombre,stock_minimo,estado,id_categoria)
VALUES(9003,25,'Producto de prueba para insercion directa','Planta de prueba C',5,'ACTIVO',1),
      (9004,18,'Producto de prueba para insercion directa','Planta de prueba D',4,'ACTIVO',1);



---VERIFICAR 
SELECT *
FROM Producto
WHERE id_producto IN (9003, 9004);


---INSERCION MEDIANTE PROCEDIMIENTO

EXEC sp_InsertarProducto
    @id_producto = 9005,
    @stock_actual = 25,
    @descripcion = 'Producto de prueba para insercion mediante procedimiento',
    @nombre = 'Planta de prueba E',
    @stock_minimo = 5,
    @estado = 'ACTIVO',
    @id_categoria = 1;

EXEC sp_InsertarProducto
    @id_producto = 9006,
    @stock_actual = 18,
    @descripcion = 'Producto de prueba para insercion mediante procedimiento',
    @nombre = 'Planta de prueba F',
    @stock_minimo = 4,
    @estado = 'ACTIVO',
    @id_categoria = 1;


---VERIFICAR
SELECT *
FROM Producto
WHERE id_producto IN (9005, 9006);



---MODIFICACION DE PRODUCTO DIRECTAMENTE

UPDATE Producto
SET
    nombre = 'Planta de prueba C modificada',
    descripcion = 'Modificacion mediante UPDATE directo',
    stock_minimo = 7
WHERE id_producto = 9003;


---VERIFICAR
SELECT *
FROM Producto
WHERE id_producto = 9003;



---MODIFICAR MEDIANTE PROCEDIMIENTO

EXEC sp_ModificarProducto
    @id_producto = 9005,
    @nombre = 'Planta de prueba E modificada',
    @descripcion = 'Modificacion mediante procedimiento',
    @stock_minimo = 7,
    @estado = 'ACTIVO';


---VERIFICAR
SELECT *
FROM Producto
WHERE id_producto = 9005;



---ELIMINAR PRODUCTO DIRECTAMENTE

DELETE FROM Producto
WHERE id_producto = 9004;


---VERIFICAR
SELECT *
FROM Producto
WHERE id_producto = 9004;


---ELIMINAR PRODUCTO MEDIANTE PROCEDIMIENTO

EXEC sp_EliminarProducto
    @id_producto = 9006;


---VERIFICAR
SELECT *
FROM Producto
WHERE id_producto = 9006;


-----------------------------------------

---MEDICIÓN DE TIEMPO DE EJECUCIÓN
SET STATISTICS TIME ON;

-- Operacion directa
UPDATE Producto
SET descripcion = 'Prueba de eficiencia'
WHERE id_producto = 9003;


-- Operacion mediante procedimiento
EXEC sp_ModificarProducto
    @id_producto = 9003,
    @nombre = 'Planta de prueba C modificada',
    @descripcion = 'Prueba de eficiencia',
    @stock_minimo = 7,
    @estado = 'ACTIVO';


SET STATISTICS TIME OFF;



---MEDICIÓN DE FUNCIONES ALMACENADAS

SET STATISTICS TIME ON;

-- Calculo mediante funcion almacenada
SELECT dbo.fn_CalcularSubtotal(1800, 2) AS subtotal;

-- Calculo directo
SELECT
    CAST(1800 AS DECIMAL(10,2))
    * CAST(2 AS INT) AS subtotal;


SET STATISTICS TIME OFF;



---MEDICION
SET STATISTICS TIME ON;

-- Consulta mediante la funcion
SELECT *
FROM dbo.fn_ProductosBajoStock();


-- Consulta directa equivalente
SELECT id_producto, nombre, stock_actual, stock_minimo
FROM Producto
WHERE stock_actual < stock_minimo;

SET STATISTICS TIME OFF;






