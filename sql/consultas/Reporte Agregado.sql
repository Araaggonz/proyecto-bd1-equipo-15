INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(43576421,'Pablo','Rodriguez','+543794998769','pablorodri@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(42158367,'Lucia','Gomez','+543794512348','luciagomez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(39874521,'Martin','Fernandez','+543794687521','martinferna@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(45231698,'Sofia','Martinez','+543794325687','sofiamartinez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(37654129,'Diego','Gonzalez','+543794789456','diegogonza@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(41452873,'Camila','Ramirez','+543794236985','camilarami@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(46783215,'Nicolas','Diaz','+543794654123','nicolasdiaz@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(38962147,'Valentina','Lopez','+543794318742','valentilopez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(39521468,'Joaquin','Sanchez','+543794521638','joaquinsanch@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(42896731,'Mariana','Torres','+543794638215','marianatorres@gmail.com');

SELECT * FROM Persona;


INSERT INTO Metodo_Pago (id_metodo, tipo_metodo_) VALUES
(1, 'EFECTIVO'),
(2, 'TARJETA_DEBITO'),
(3, 'TARJETA_CREDITO'),
(4, 'TRANSFERENCIA');

SELECT * FROM Metodo_Pago;

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(1,1001,'2026-09-01','Pendiente');

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(2,1002,'2026-09-01','Pagado');

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(3,1003,'2026-05-05','Pendiente');

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(4,1004,'2026-05-08','Pagado');

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(5,1005,'2026-05-10','Cancelado');

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(6,1006,'2026-03-15','Pagado');

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(7,1007,'2026-03-20','Pendiente');

INSERT INTO Comprobante (id_comprobante,numero,fecha,estado_) VALUES
(8,1008,'2026-09-25','Pagado');

SELECT * FROM Comprobante;

INSERT INTO Categoria (id_categoria, nombre_, descripcion) VALUES
(1, 'Plantas de interior', 'Plantas ornamentales para ambientes cerrados'),
(2, 'Plantas de exterior', 'Plantas y arbustos para jardin o patio'),
(3, 'Semillas', 'Semillas de flores, hortalizas y arboles'),
(4, 'Macetas', 'Macetas de barro, plastico y ceramica'),
(5, 'Sustratos y tierra', 'Tierra, sustrato y compost para plantacion'),
(6, 'Fertilizantes', 'Abonos organicos y quimicos'),
(7, 'Herramientas', 'Palas, tijeras de podar, rastrillos, regaderas'),
(8, 'Riego', 'Mangueras, aspersores y sistemas de riego');

SELECT * FROM Categoria;

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(1,43576421);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(2,42158367);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(3,39874521);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(4,45231698);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(5,37654129);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(6,41452873);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(7,39521468);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(8,42896731);

SELECT * FROM Cliente;

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(1,'San Martin 1234',43576421);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(2,'Junin 567',42158367);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(3,'Belgrano 890',39874521);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(4,'25 de Mayo 456',45231698);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(5,'Bolivar 789',37654129);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(6,'Colon 321',41452873);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(7,'Mendoza 654',46783215);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(8,'Rivadavia 987',38962147);

SELECT * FROM Proveedor;

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(1,43576421);

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(2,42158367);

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(3,39874521);

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(4,45231698);

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(5,37654129);

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(6,41452873);

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(7,46783215);

INSERT INTO Vendedor (id_vendedor,DNI_vendedor) VALUES
(8,38962147);

SELECT * FROM Vendedor;

INSERT INTO Producto (id_producto, stock_actual, descripcion, nombre, stock_minimo, estado, id_categoria) VALUES
(1, 25, 'Potus en maceta de 12cm', 'Potus', 5, 'ACTIVO', 1),
(2, 15, 'Suculenta variada en maceta chica', 'Suculenta mix', 5, 'ACTIVO', 1),
(3, 10, 'Rosal de exterior a raiz desnuda', 'Rosal', 3, 'ACTIVO', 2),
(4, 8, 'Lavanda en maceta de 15cm', 'Lavanda', 3, 'ACTIVO', 2),
(5, 40, 'Sobre de semillas de tomate', 'Semillas de tomate', 10, 'ACTIVO', 3),
(6, 30, 'Maceta de barro de 20cm', 'Maceta barro 20cm', 8, 'ACTIVO', 4),
(7, 50, 'Bolsa de sustrato universal x5kg', 'Sustrato universal 5kg', 10, 'ACTIVO', 5),
(8, 20, 'Fertilizante liquido multiuso x500ml', 'Fertilizante liquido 500ml', 5, 'ACTIVO', 6),
(9, 12, 'Pala de mano de jardin', 'Pala de mano', 4, 'ACTIVO', 7),
(10, 6, 'Regadera plastica de 5 litros', 'Regadera 5L', 2, 'ACTIVO', 7);

SELECT * FROM Producto;

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(1,'2026-09-01',12500.00,1,1,3,1);

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(2,'2026-09-01',18750.50,2,2,2,1);

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(3,'2026-05-05',9500.00,3,3,5,1);

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(4,'2026-05-08',22300.75,4,4,8,4);

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(5,'2026-05-10',15780.00,1,5,5,4);

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(6,'2026-03-15',31250.25,2,6,6,7);

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(7,'2026-03-20',8900.00,3,7,4,7);

INSERT INTO Venta (id_venta,fecha_,total,id_metodo,id_comprobante,id_cliente,id_vendedor) VALUES
(8,'2026-09-25',27450.50,4,8,2,7);

SELECT * FROM Venta;

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(1,45000.00,'2026-09-01',1,3);

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(2,32750.50,'2026-09-04',1,2);

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(3,58900.00,'2026-07-07',3,8);

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(4,41250.75,'2026-02-10',3,4);

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(5,63500.00,'2026-02-13',3,2);

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(6,29800.25,'2026-02-17',3,4);

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(7,52100.00,'2026-02-21',5,7);

INSERT INTO Compra (id_compra,total,fecha_,id_proveedor,id_vendedor) VALUES
(8,36750.50,'2026-07-26',5,8);

SELECT * FROM Compra;

INSERT INTO Producto_Venta (precio_unitario, cantidad, sub_total, id_producto, id_venta) VALUES
(2500.00, 5, 12500.00, 1, 1),
(1500.10, 5, 7500.50, 2, 2),
(750.00, 15, 11250.00, 6, 2),
(475.00, 20, 9500.00, 5, 3),
(1850.00, 5, 9250.00, 3, 4),
(870.05, 15, 13050.75, 8, 4),
(526.00, 30, 15780.00, 7, 5),
(950.00, 5, 4750.00, 9, 6),
(1200.00, 3, 3600.00, 4, 7),
(1800.00, 2, 3600.00, 10, 8);

SELECT * FROM Producto_Venta;

INSERT INTO Producto_Compra (precio_unitario, cantidad, subtotal_, id_producto, id_compra) VALUES
(1500.00, 30, 45000.00, 1, 1),
(1310.02, 25, 32750.50, 2, 2),
(2945.00, 20, 58900.00, 3, 3),
(2750.05, 15, 41250.75, 4, 4),
(1270.00, 50, 63500.00, 5, 5),
(800.00, 20, 16000.00, 6, 6),
(552.01, 25, 13800.25, 7, 6),
(2000.00, 10, 20000.00, 8, 7),
(2140.00, 15, 32100.00, 9, 7),
(3675.05, 10, 36750.50, 10, 8);

SELECT * FROM Producto_Compra;

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(1,'Producto vencido','2026-06-01',5,1);

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(2,'Producto dañado','2026-06-03',3,2);

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(3,'Envase roto','2026-03-05',2,3);

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(4,'Producto vencido','2026-02-08',4,4);

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(5,'Mala conservación','2026-02-10',6,5);

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(6,'Producto dañado','2026-08-15',2,6);

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(7,'Envase roto','2026-08-20',3,7);

INSERT INTO Merma (id_merma,motivo,fecha,cantidad,id_producto) VALUES
(8,'Producto vencido','2026-08-25',1,8);

SELECT * FROM Merma;

---comprobar
SELECT COUNT(*) AS cantidad_personas
FROM Persona;


SELECT COUNT(*) AS cantidad_categorias
FROM Categoria;


---Total de ventas por vendedor en un rango de fechas
SELECT
    id_vendedor,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_vendido
FROM Venta
WHERE fecha_ >= '2026-05-01'
  AND fecha_ < '2026-06-01'
GROUP BY id_vendedor;


---Total de ventas por categoría de producto en un rango de fechas
SELECT
    C.id_categoria,
    C.nombre_,
    COUNT(DISTINCT V.id_venta) AS cantidad_ventas,
    SUM(PV.cantidad) AS unidades_vendidas,
    SUM(PV.sub_total) AS total_vendido
FROM Venta AS V
INNER JOIN Producto_Venta AS PV
    ON V.id_venta = PV.id_venta
INNER JOIN Producto AS P
    ON PV.id_producto = P.id_producto
INNER JOIN Categoria AS C
    ON P.id_categoria = C.id_categoria
WHERE V.fecha_ >= '2026-09-01'
  AND V.fecha_ < '2026-10-01'
GROUP BY
    C.id_categoria,
    C.nombre_;


---Ventas que incluyen productos de una categoría específica
SELECT DISTINCT
    V.id_venta,
    V.fecha_,
    V.total
FROM Venta AS V
INNER JOIN Producto_Venta AS PV
    ON V.id_venta = PV.id_venta
INNER JOIN Producto AS P
    ON PV.id_producto = P.id_producto
INNER JOIN Categoria AS C
    ON P.id_categoria = C.id_categoria
WHERE C.nombre_ = 'Plantas de interior'
  AND V.fecha_ >= '2026-03-01'
  AND V.fecha_ < '2026-04-01';


---mostrar los productos que necesitan reposicion 

  SELECT
    id_producto,
    nombre,
    stock_actual,
    stock_minimo
FROM Producto
WHERE stock_actual <= stock_minimo;




