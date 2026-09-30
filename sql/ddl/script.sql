CREATE DATABASE VERDE_ENCANTO;

CREATE TABLE Persona
(
  DNI VARCHAR(10) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  correo_electronico VARCHAR(50) NOT NULL,
  CONSTRAINT PK_persona_dni PRIMARY KEY (DNI),
  CONSTRAINT UQ_persona_telefono UNIQUE (telefono),
  CONSTRAINT UQ_persona_correo UNIQUE (correo_electronico)
);

CREATE TABLE Proveedor
(
  id_proveedor INT NOT NULL,
  direccion VARCHAR(80) NOT NULL,
  DNI_proveedor VARCHAR(10) NOT NULL,
  CONSTRAINT PK_proveedor_id PRIMARY KEY (id_proveedor),
  CONSTRAINT FK_persona_proveedor FOREIGN KEY (DNI_proveedor) REFERENCES Persona(DNI)
);

CREATE TABLE Cliente
(
  id_cliente INT NOT NULL,
  DNI_cliente VARCHAR(10) NOT NULL,
  CONSTRAINT PK_cliente_id PRIMARY KEY (id_cliente),
  CONSTRAINT FK_persona_cliente FOREIGN KEY (DNI_cliente) REFERENCES Persona(DNI)
);

CREATE TABLE Vendedor
(
  id_vendedor INT NOT NULL,
  DNI_vendedor VARCHAR(10)  NOT NULL,
  CONSTRAINT PK_vendedor_id PRIMARY KEY (id_vendedor),
  CONSTRAINT FK_persona_vendedor FOREIGN KEY (DNI_vendedor) REFERENCES Persona(DNI)
);

CREATE TABLE Metodo_Pago
(
  id_metodo INT NOT NULL,
  tipo_metodo_ VARCHAR(20) NOT NULL,
  CONSTRAINT PK_metodo_id PRIMARY KEY (id_metodo)
);

CREATE TABLE Comprobante
(
  id_comprobante INT NOT NULL,
  numero INT NOT NULL,
  fecha DATE NOT NULL,
  estado_ VARCHAR(80) NOT NULL,
  CONSTRAINT PK_comprobante_id PRIMARY KEY (id_comprobante)
);

CREATE TABLE Venta
(
  id_venta INT NOT NULL,
  fecha_ DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  id_metodo INT NOT NULL,
  id_comprobante INT NOT NULL,
  id_cliente INT NOT NULL,
  id_vendedor INT NOT NULL,
  CONSTRAINT PK_venta_id PRIMARY KEY (id_venta),
  CONSTRAINT FK_venta_metodo FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo),
  CONSTRAINT FK_venta_comprobante FOREIGN KEY (id_comprobante) REFERENCES Comprobante(id_comprobante),
  CONSTRAINT FK_venta_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor),
  CONSTRAINT FK_venta_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Categoria
(
  id_categoria INT NOT NULL,
  nombre_ VARCHAR(50) NOT NULL,
  descripcion VARCHAR(80) NOT NULL,
  CONSTRAINT PK_categoria_id PRIMARY KEY (id_categoria)
);

CREATE TABLE Producto
(
  id_producto INT NOT NULL,
  stock_actual INT NOT NULL,
  descripcion VARCHAR(80) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  stock_minimo INT NOT NULL,
  estado VARCHAR(80) NOT NULL,
  id_categoria INT NOT NULL,
  CONSTRAINT PK_producto_id PRIMARY KEY (id_producto),
  CONSTRAINT FK_producto_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Compra
(
  id_compra INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  fecha_ DATE NOT NULL,
  id_proveedor INT NOT NULL,
  id_vendedor INT NOT NULL,
  CONSTRAINT PK_compra_id PRIMARY KEY (id_compra),
  CONSTRAINT FK_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
  CONSTRAINT FK_compra_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

CREATE TABLE Producto_Venta
(
  precio_unitario DECIMAL(10,2) NOT NULL,
  cantidad INT NOT NULL,
  sub_total DECIMAL(10,2) NOT NULL,
  id_producto INT NOT NULL,
  id_venta INT NOT NULL,
  CONSTRAINT PK_producto_venta PRIMARY KEY (id_producto, id_venta),
  CONSTRAINT FK_producto_venta FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  CONSTRAINT Fk_venta_producto FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE Producto_Compra
(
  precio_unitario DECIMAL(10,2) NOT NULL,
  cantidad INT NOT NULL,
  subtotal_ DECIMAL(10,2) NOT NULL,
  id_producto INT NOT NULL,
  id_compra INT NOT NULL,
  CONSTRAINT PK_producto_compra PRIMARY KEY (id_producto, id_compra),
  CONSTRAINT FK_producto_compra FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  CONSTRAINT Fk_compra_pruducto FOREIGN KEY (id_compra) REFERENCES Compra(id_compra)
);

CREATE TABLE Merma
(
  id_merma INT NOT NULL,
  motivo VARCHAR(50) NOT NULL,
  fecha DATE NOT NULL,
  cantidad INT NULL,
  id_producto INT NOT NULL,
  CONSTRAINT PK_merma_id PRIMARY KEY (id_merma),
  CONSTRAINT FK_merma_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

ALTER TABLE Producto
ADD CONSTRAINT CK_producto_stock_actual CHECK (stock_actual >= 0);

ALTER TABLE Producto
ADD CONSTRAINT CK_producto_stock_minimo CHECK (stock_minimo >= 0);

ALTER TABLE Producto
ADD CONSTRAINT CK_producto_estado CHECK (estado IN ('ACTIVO', 'INACTIVO'));

ALTER TABLE Producto_Venta
ADD CONSTRAINT CK_producto_venta_cantidad CHECK (cantidad > 0);

ALTER TABLE Producto_Compra
ADD CONSTRAINT CK_producto_compra_cantidad CHECK (cantidad > 0);

ALTER TABLE Producto_Venta
ADD CONSTRAINT CK_producto_venta_precio CHECK (precio_unitario > 0);

ALTER TABLE Producto_Compra
ADD CONSTRAINT CK_producto_compra_precio CHECK (precio_unitario > 0);

ALTER TABLE Merma
ADD CONSTRAINT CK_merma_cantidad CHECK (cantidad > 0);

ALTER TABLE Comprobante
ADD CONSTRAINT UQ_comprobante_numero UNIQUE (numero);