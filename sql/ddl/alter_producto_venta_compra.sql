USE VERDE_ENCANTO;

-- ==========================================================
-- Producto_Venta: reglas de borrado/modificacion en sus 2 FK
-- ==========================================================
ALTER TABLE Producto_Venta
DROP CONSTRAINT FK_producto_venta;

ALTER TABLE Producto_Venta
ADD CONSTRAINT FK_producto_venta FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;

ALTER TABLE Producto_Venta
DROP CONSTRAINT Fk_venta_producto;

ALTER TABLE Producto_Venta
ADD CONSTRAINT Fk_venta_producto FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;

-- Validar que el subtotal tambien sea positivo (igual que cantidad y precio_unitario)
ALTER TABLE Producto_Venta
ADD CONSTRAINT CK_producto_venta_subtotal CHECK (sub_total > 0);

-- ==========================================================
-- Producto_Compra: reglas de borrado/modificacion en sus 2 FK
-- ==========================================================
ALTER TABLE Producto_Compra
DROP CONSTRAINT FK_producto_compra;

ALTER TABLE Producto_Compra
ADD CONSTRAINT FK_producto_compra FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;

ALTER TABLE Producto_Compra
DROP CONSTRAINT Fk_compra_pruducto;

ALTER TABLE Producto_Compra
ADD CONSTRAINT Fk_compra_pruducto FOREIGN KEY (id_compra) REFERENCES Compra(id_compra)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;

ALTER TABLE Producto_Compra
ADD CONSTRAINT CK_producto_compra_subtotal CHECK (subtotal_ > 0);