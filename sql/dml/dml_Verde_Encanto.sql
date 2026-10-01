USE VERDE_ENCANTO;

-- ==========================================================
-- Categoria (va primero: Producto depende de ella con la FK)
-- ==========================================================
INSERT INTO Categoria (id_categoria, nombre_, descripcion) VALUES
(1, 'Plantas de interior', 'Plantas ornamentales para ambientes cerrados'),
(2, 'Plantas de exterior', 'Plantas y arbustos para jardin o patio'),
(3, 'Semillas', 'Semillas de flores, hortalizas y arboles'),
(4, 'Macetas', 'Macetas de barro, plastico y ceramica'),
(5, 'Sustratos y tierra', 'Tierra, sustrato y compost para plantacion'),
(6, 'Fertilizantes', 'Abonos organicos y quimicos'),
(7, 'Herramientas', 'Palas, tijeras de podar, rastrillos, regaderas'),
(8, 'Riego', 'Mangueras, aspersores y sistemas de riego');

-- ==========================================================
-- Metodo_Pago
-- Nota: solo hay 4 valores posibles porque el CHECK del script
-- (CK_metodo_tipo) restringe el campo a esas 4 opciones (RN.07).
-- Por eso esta tabla tiene 4 filas en vez de 8-10: su dominio
-- de valores es naturalmente chico, no hace falta forzar mas.
-- ==========================================================
INSERT INTO Metodo_Pago (id_metodo, tipo_metodo_) VALUES
(1, 'EFECTIVO'),
(2, 'TARJETA_DEBITO'),
(3, 'TARJETA_CREDITO'),
(4, 'TRANSFERENCIA');

-- ==========================================================
-- Producto (depende de Categoria por la FK id_categoria)
-- ==========================================================
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

USE VERDE_ENCANTO;

-- ==========================================================
-- Producto_Venta
-- ==========================================================
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

-- ==========================================================
-- Producto_Compra
-- ==========================================================
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