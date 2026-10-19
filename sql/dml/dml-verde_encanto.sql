---registros de personas

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


---más registros de Persona

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(37524583,'Maria','Gomez','+543794656323','mariagomez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(23756498,'Pedro','Fernandez','+543794784653','pedrofernanadez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(407254841,'Marcos','Valdes','+543794874629','marcosvaldes@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(34586922,'Gustavo','Sanchez','+543794331780','gustavosanchez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(39875744,'Ernestina','Mendez','+543794775690','ernestinamendez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(39746600,'Romina','Toledo','+543794556374','rominatoledo@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(25788421,'Martin','vasquez','+543794924431','martinvasquez@gmail.com');

INSERT INTO Persona (DNI,nombre,apellido,telefono,correo_electronico) VALUES
(25837466,'Juana','Lopez','+543794667702','juanalopez@gmail.com');

---registros de proveedor

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(1,'San Martin 1234',43576421);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(2,'Junin 567',42158367);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(3,'Belgrano 890',39874521);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(4,'25 de Mayo 456',45231698);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(5,'Bolivar 789',37524583);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(6,'Colon 321',23756498);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(7,'Mendoza 654',407254841);

INSERT INTO Proveedor (id_proveedor,direccion,DNI_proveedor) VALUES
(8,'Rivadavia 987',34586922);


---registros de clientes

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(1,39875744);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(2,39746600);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(3,25788421);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(4,25837466);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(5,37654129);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(6,41452873);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(7,39521468);

INSERT INTO Cliente (id_cliente,DNI_cliente) VALUES
(8,42896731);


---registros de comprobantes

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


---registros de mermas

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
