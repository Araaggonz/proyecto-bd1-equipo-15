
---procedimiento de insertar un producto
CREATE OR ALTER PROCEDURE sp_InsertarProducto
    @id_producto INT,
    @stock_actual INT,
    @descripcion VARCHAR(80),
    @nombre VARCHAR(50),
    @stock_minimo INT,
    @estado VARCHAR(80),
    @id_categoria INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Producto (
        id_producto,
        stock_actual,
        descripcion,
        nombre,
        stock_minimo,
        estado,
        id_categoria
    )
    VALUES (
        @id_producto,
        @stock_actual,
        @descripcion,
        @nombre,
        @stock_minimo,
        @estado,
        @id_categoria
    );
END;


---procedimiento de modificar un producto
CREATE OR ALTER PROCEDURE sp_ModificarProducto
    @id_producto INT,
    @nombre VARCHAR(50),
    @descripcion VARCHAR(80),
    @stock_minimo INT,
    @estado VARCHAR(80)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Producto
    SET
        nombre = @nombre,
        descripcion = @descripcion,
        stock_minimo = @stock_minimo,
        estado = @estado
    WHERE id_producto = @id_producto;

    IF @@ROWCOUNT = 0
        THROW 50010, 'No existe el producto indicado.', 1;
END;




---procedimiento de eliminar un producto
CREATE OR ALTER PROCEDURE sp_EliminarProducto
    @id_producto INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Producto
    WHERE id_producto = @id_producto;

    IF @@ROWCOUNT = 0
        THROW 50011, 'No existe el producto indicado.', 1;
END;




---verificar
SELECT
    name AS procedimiento,
    create_date AS fecha_creacion
FROM sys.procedures
WHERE name IN (
    'sp_InsertarProducto',
    'sp_ModificarProducto',
    'sp_EliminarProducto'
)
ORDER BY name;


---PRUEBA DE INSERTAR PRODUCTOS USANDO PROCEDIMIENTO ALMACENADO

EXEC sp_InsertarProducto
    @id_producto = 9001,
    @stock_actual = 20,
    @descripcion = 'Producto de prueba para procedimientos',
    @nombre = 'Planta de prueba A',
    @stock_minimo = 5,
    @estado = 'ACTIVO',
    @id_categoria = 1;

EXEC sp_InsertarProducto
    @id_producto = 9002,
    @stock_actual = 15,
    @descripcion = 'Producto de prueba para procedimientos',
    @nombre = 'Planta de prueba B',
    @stock_minimo = 4,
    @estado = 'ACTIVO',
    @id_categoria = 1;


---VERIFICAR QUE SE HAYAN INSERTADO
SELECT *
FROM Producto
WHERE id_producto IN (9001, 9002);


---PRUEBA DE MODIFACION DE UN PRODUCTO
EXEC sp_ModificarProducto
    @id_producto = 9001,
    @nombre = 'Planta de prueba A modificada',
    @descripcion = 'Descripcion modificada para la prueba',
    @stock_minimo = 6,
    @estado = 'ACTIVO';


 ---VERIFICAR
SELECT *
FROM Producto
WHERE id_producto = 9001;


---PROBAR ELIMINACION DE PRODUCTO
EXEC sp_EliminarProducto
    @id_producto = 9002;


---VERIFICAR
SELECT *
FROM Producto
WHERE id_producto = 9002;









