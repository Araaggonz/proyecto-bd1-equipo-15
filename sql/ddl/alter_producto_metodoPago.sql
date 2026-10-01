USE VERDE_ENCANTO;

-- 1) Categoria: que no se repita el nombre de una categoria
ALTER TABLE Categoria
ADD CONSTRAINT UQ_categoria_nombre UNIQUE (nombre_);

-- 2) Metodo_Pago: que no se repita el tipo, y que solo acepte los 4 valores de RN.07
ALTER TABLE Metodo_Pago
ADD CONSTRAINT UQ_metodo_tipo UNIQUE (tipo_metodo_);

ALTER TABLE Metodo_Pago
ADD CONSTRAINT CK_metodo_tipo CHECK (tipo_metodo_ IN ('EFECTIVO', 'TARJETA_DEBITO', 'TARJETA_CREDITO', 'TRANSFERENCIA'));

-- 3) Producto: agregar reglas de borrado/modificacion a la FK con Categoria
-- Primero hay que borrar la FK vieja (sin reglas) y crearla de nuevo con las reglas.
-- OJO: si tu compañera le puso otro nombre a esta constraint, cambialo acá
-- (fijate en SSMS: Object Explorer > Producto > Keys, para confirmar el nombre real).
ALTER TABLE Producto
DROP CONSTRAINT FK_producto_categoria;

ALTER TABLE Producto
ADD CONSTRAINT FK_producto_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;