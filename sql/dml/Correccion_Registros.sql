
---registros agregados de personas

INSERT INTO Persona (DNI, nombre, apellido, telefono, correo_electronico)
VALUES ('37524583', 'Maria', 'Gomez', '+543794656323', 'mariagomez@gmail.com'), 
(23756498, 'Pedro', 'Fernandez', '+543794784653', 'pedrofernandez@gmail.com'), 
(40725484, 'Marcos', 'Valdes', '+543794874629', 'marcosvaldes@gmail.com'), 
(34586922, 'Gustavo', 'Sanchez', '+543794331780', 'gustavosanchez@gmail.com'), 
(39875744, 'Ernestina', 'Mendez', '+543794775690', 'ernestinamendez@gmail.com'), 
(39746600, 'Romina', 'Toledo', '+543794556374', 'rominatoledo@gmail.com'), 
(25788421, 'Martin', 'Vasquez', '+543794924431', 'martinvasquez@gmail.com'), 
(25837466, 'Juana', 'Lopez', '+543794667702', 'juanalopez@gmail.com');

SELECT
    DNI,
    nombre,
    apellido,
    telefono,
    correo_electronico
FROM Persona
ORDER BY DNI;


SELECT
    id_cliente,
    DNI_cliente
FROM Cliente
ORDER BY id_cliente;


SELECT
    id_proveedor,
    DNI_proveedor,
    direccion
FROM Proveedor
ORDER BY id_proveedor;


SELECT
    id_vendedor,
    DNI_vendedor
FROM Vendedor
ORDER BY id_vendedor;



BEGIN TRANSACTION;
--- 1. REDISTRIBUIR LOS CLIENTES

UPDATE Cliente
SET DNI_cliente = CASE id_cliente
    WHEN 1 THEN '39521468' -- Joaquin Sanchez
    WHEN 2 THEN '42896731' -- Mariana Torres
    WHEN 3 THEN '39874521' -- Martin Fernandez
    WHEN 4 THEN '45231698' -- Sofia Martinez
    WHEN 5 THEN '37654129' -- Diego Gonzalez
    WHEN 6 THEN '41452873' -- Camila Ramirez
    WHEN 7 THEN '37524583' -- Maria Gomez
    WHEN 8 THEN '34586922' -- Gustavo Sanchez
END
WHERE id_cliente BETWEEN 1 AND 8;


--- 2. REDISTRIBUIR LOS VENDEDORES

UPDATE Vendedor
SET DNI_vendedor = CASE id_vendedor
    WHEN 1 THEN '43576421' -- Pablo Rodriguez
    WHEN 2 THEN '42158367' -- Lucia Gomez
    WHEN 3 THEN '38962147' -- Valentina Lopez
    WHEN 4 THEN '39746600' -- Romina Toledo
    WHEN 5 THEN '40725484' -- Marcos Valdes
    WHEN 6 THEN '23756498' -- Pedro Fernandez
    WHEN 7 THEN '46783215' -- Nicolas Diaz
    WHEN 8 THEN '25837466' -- Juana Lopez
END
WHERE id_vendedor BETWEEN 1 AND 8;


--- 3. REDISTRIBUIR LOS PROVEEDORES

UPDATE Proveedor
SET DNI_proveedor = CASE id_proveedor
    WHEN 1 THEN '39875744' -- Ernestina Mendez
    WHEN 2 THEN '25788421' -- Martin Vasquez
    WHEN 3 THEN '23756498' -- Pedro Fernandez
    WHEN 4 THEN '38962147' -- Valentina Lopez
    WHEN 5 THEN '37524583' -- Maria Gomez
    WHEN 6 THEN '39521468' -- Joaquin Sanchez
    WHEN 7 THEN '41452873' -- Camila Ramirez
    WHEN 8 THEN '40725484' -- Marcos Valdes
END
WHERE id_proveedor BETWEEN 1 AND 8;


--- 4. VERIFICAR LOS CAMBIOS
SELECT
    C.id_cliente,
    P.nombre,
    P.apellido,
    P.DNI
FROM Cliente C
INNER JOIN Persona P ON C.DNI_cliente = P.DNI
ORDER BY C.id_cliente;

SELECT
    V.id_vendedor,
    P.nombre,
    P.apellido,
    P.DNI
FROM Vendedor V
INNER JOIN Persona P ON V.DNI_vendedor = P.DNI
ORDER BY V.id_vendedor;

SELECT
    PR.id_proveedor,
    P.nombre,
    P.apellido,
    P.DNI,
    PR.direccion
FROM Proveedor PR
INNER JOIN Persona P ON PR.DNI_proveedor = P.DNI
ORDER BY PR.id_proveedor;


COMMIT TRANSACTION;


--- actualizacion de monto total en las ventas 6, 7 y 8
BEGIN TRANSACTION;

UPDATE Venta
SET total = 4750.00
WHERE id_venta = 6;

UPDATE Venta
SET total = 3600.00
WHERE id_venta = 7;

UPDATE Venta
SET total = 3600.00
WHERE id_venta = 8;


--- actualizacion de fechas
BEGIN TRANSACTION;

--- 1. ACTUALIZAR FECHAS DE LAS VENTAS

UPDATE Venta
SET fecha_ = CASE id_venta
    WHEN 1 THEN '2026-03-01'
    WHEN 2 THEN '2026-03-05'
    WHEN 3 THEN '2026-03-10'
    WHEN 4 THEN '2026-03-15'
    WHEN 5 THEN '2026-03-20'
    WHEN 6 THEN '2026-03-25'
    WHEN 7 THEN '2026-03-30'
    WHEN 8 THEN '2026-04-05'
END
WHERE id_venta BETWEEN 1 AND 8;


--- 2. ACTUALIZAR FECHAS DE LAS COMPRAS

UPDATE Compra
SET fecha_ = CASE id_compra
    WHEN 1 THEN '2026-02-01'
    WHEN 2 THEN '2026-02-05'
    WHEN 3 THEN '2026-02-10'
    WHEN 4 THEN '2026-02-15'
    WHEN 5 THEN '2026-02-20'
    WHEN 6 THEN '2026-02-25'
    WHEN 7 THEN '2026-03-05'
    WHEN 8 THEN '2026-03-10'
END
WHERE id_compra BETWEEN 1 AND 8;


--- 3. ACTUALIZAR FECHAS DE LOS COMPROBANTES

UPDATE Comprobante
SET fecha = CASE id_comprobante
    WHEN 1 THEN '2026-03-01'
    WHEN 2 THEN '2026-03-05'
    WHEN 3 THEN '2026-03-10'
    WHEN 4 THEN '2026-03-15'
    WHEN 5 THEN '2026-03-20'
    WHEN 6 THEN '2026-03-25'
    WHEN 7 THEN '2026-03-30'
    WHEN 8 THEN '2026-04-05'
END
WHERE id_comprobante BETWEEN 1 AND 8;


--- 4. ACTUALIZAR FECHAS DE LAS MERMAS

UPDATE Merma
SET fecha = CASE id_merma
    WHEN 1 THEN '2026-04-10'
    WHEN 2 THEN '2026-04-12'
    WHEN 3 THEN '2026-04-15'
    WHEN 4 THEN '2026-04-18'
    WHEN 5 THEN '2026-04-20'
    WHEN 6 THEN '2026-04-22'
    WHEN 7 THEN '2026-04-25'
    WHEN 8 THEN '2026-04-28'
END
WHERE id_merma BETWEEN 1 AND 8;



--- 5. VERIFICAR LOS RESULTADOS

SELECT id_venta, fecha_, total
FROM Venta
ORDER BY id_venta;

SELECT id_compra, fecha_, total
FROM Compra
ORDER BY id_compra;

SELECT id_comprobante, fecha, numero, estado_
FROM Comprobante
ORDER BY id_comprobante;

SELECT id_merma, motivo, fecha, cantidad, id_producto
FROM Merma
ORDER BY id_merma;


COMMIT TRANSACTION;


--- actualizacion del stock de los productos

BEGIN TRANSACTION;

UPDATE Producto
SET stock_actual = CASE id_producto
    WHEN 1 THEN 45
    WHEN 2 THEN 32
    WHEN 3 THEN 23
    WHEN 4 THEN 16
    WHEN 5 THEN 64
    WHEN 6 THEN 33
    WHEN 7 THEN 42
    WHEN 8 THEN 14
    WHEN 9 THEN 22
    WHEN 10 THEN 14
END
WHERE id_producto BETWEEN 1 AND 10;


-- Verificar los nuevos valores
SELECT
    id_producto,
    nombre,
    stock_actual
FROM Producto
ORDER BY id_producto;


COMMIT TRANSACTION;








