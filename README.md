<div align="center">

<img src="assets/logo-verde-encanto.png" alt="Logo Verde Encanto" width="280"/>

# 🌿 Verde Encanto
### Sistema de gestión de ventas, stock y abastecimiento para un vivero y tienda de jardinería

**Proyecto de Base de Datos I · Equipo 15**

![SQL Server](https://img.shields.io/badge/SQL%20Server-4E7A2E?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![SSMS](https://img.shields.io/badge/SSMS-6B8F47?style=for-the-badge&logo=microsoft&logoColor=white)
![Git](https://img.shields.io/badge/Git-4E7A2E?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-6B8F47?style=for-the-badge&logo=github&logoColor=white)
![Markdown](https://img.shields.io/badge/Markdown-4E7A2E?style=for-the-badge&logo=markdown&logoColor=white)

</div>

---

## Tabla de contenidos

- [Descripción](#descripción)
- [Objetivo](#objetivo)
- [Alcance](#alcance)
- [Documentación del proyecto](#documentación-del-proyecto)
- [Modelos](#modelos)
- [Código SQL](#código-sql)
- [Integrantes](#integrantes)
- [Tecnologías y herramientas](#tecnologías-y-herramientas)

---

## 🌱 Descripción del proyecto

**Verde Encanto** es un sistema de bases de datos relacional diseñado para un vivero y tienda de jardineria que comercializa plantas de interior y exterior, semillas, macetas, sustratos, fertilizantes, herramientas, sistemas de riego y complementos del ámbito. 

El proyecto abarca el **diseño conceptual, el diseño lógico (con normalización) y la implementacion fisica** en **Microsoft SQL Server** e integra en un único modelo la gestión de: 

- **Productos y Categorías**, con precio vigente, stock actual, stock minimo y estado (activo/inactivo).
- **Personas y sus roles**: Clientes, vendedores y proveedores, modelado a partir de una entidad `Persona` para evitar la duplicacion de datos personales.
- **Ventas**, con cabecera, detalle por producto, método de pago y comprobante asociado.
- **Mermas**, es decir, perdidas por marchitamiento, plagas o daños, registradas con fecha, cantidad y motivo.

El modelo contempla situaciones propias del rubro: el **control de stock mínimo¨¨ para identificar productos a reponer, el **historial de precios** (cada detalle de venta conserva el precio unitario vigente al momento de la operación) y la **conservación de comprobantes**, que nunca se eliminan físicamente sino que se pasan a un estado de anulación. 

La integridad de los datos se garantiza a nivel de motor mediante **claves primarias y foráneas** (con reglas de borrado y actualización) restricciones  `UNIQUE ` y  `CHECK ` (stock no negativo, cantidades y precios positivos, métodos de pago validos, estados permitidos), de modo que las reglas de negocio del sistema no dependan únicamente de la aplicación.   

## 🎯 Objetivos

## Objetivo General 

Diseñar e implementar una base de datos relacional en SQL Server que gestione de forma **integra, consistente y trazable** la información comercial de un vivero: Productos, clientes, proveedores, compras, ventas, stock, mermas y comprobantes. 

## Objetivos específicos 

- Relevar el alcance y las **reglas de negocio** (explicitas e implícitas) del vivero, y traducirlas a un modelo de datos.
- Construir el **modelo conceptual** (diagrama entidad-relación) y derivar el **modelo lógico**, aplicando normalización para eliminar redundancias.
- Garantizar la **consistencia del stock**, evitando valores negativos y reflejando los movimientos de compras, ventas y mermas.
- Preservar la **integridad histórica**: precios por operación, comprobantes y registros con operaciones asociadas, que se desactivan en lugar de eliminarse.
- Cargar **datos de prueba** (DML) y resolver **consultas y reportes** de ventas que den soporte a la toma de decisiones.
- Incorporar mecanismos avanzados del motor (Etapa 5): **seguridad por usuarios, roles y permisos**, y **optimización de consultas mediante índices**.

## Alcance

El sistema contempla, entre otras, las siguientes funcionalidades:

- Registro y gestión de clientes.
- Registro y gestión de proveedores.
- Gestión de productos y categorías.
- Registro de compras.
- Registro de ventas.
- Gestión de métodos de pago.
- Control y actualización del stock.
- Registro de los detalles de las operaciones.
- Generación y conservación de comprobantes.

## 📚 Etapas del proyecto

| Etapa | Descripción | Documento |
|:-----:|-------------|-----------|
| 1 | Alcance y funcionalidades | [Documentación de la Etapa 1](docs/etapa-01/alcance-funcionalidades.md) |
| 2 | Modelo conceptual | [Modelo conceptual](docs/etapa-02/modelo-conceptual.md) |
| 3 | Implementación SQL | [Documentación de la Etapa 3](docs/etapa-03/ddl-sql.md) |
| 4 | Consultas SQL y reportes | [Documentación de la Etapa 4](docs/etapa-04/reporte-agregado.md) |
| 5 | Temas Técnicos y evolución  | [Documentación de la Etapa 5](docs/etapa-05) |

## Modelos

### Modelo conceptual

<div align="center">

![Modelo conceptual](modelos/der/modelo-conceptual.png)

</div>


## Código SQL

| Tipo | Descripción | Archivo |
|:----:|-------------|---------|
| DDL | Creación de la estructura de la base de datos | [script.sql](sql/ddl/script.sql) |
| DDL | Modificación de producto y método de pago | [alter_producto_metodoPago.sql](sql/ddl/alter_producto_metodoPago.sql) |
| DML | Inserción de datos de prueba | [dml_Verde_Encanto.sql](sql/dml/dml_Verde_Encanto.sql) |
| DML | Corrección de registros y stock | [Correccion_Registros.sql](sql/dml/Correccion_Registros.sql) |
| Consultas | Consulta de negocio avanzada | [consulta_avanzada.sql](sql/consultas/consulta_avanzada.sql) |
| Consultas | Factura y comprobante | [Factura_Comprobante.sql](sql/consultas/Factura_Comprobante.sql) |
| Consultas | Reporte agregado | [Reporte Agregado.sql](sql/consultas/Reporte%20Agregado.sql) |

### Temas técnicos

| Tema | Descripción | Archivos |
|:----:|-------------|----------|
| Procedimientos y funciones | Procedimientos almacenados, funciones y comparaciones | [Procedimiento.sql](sql/tecnico/Procedimiento_Funciones/Procedimiento.sql) · [Funciones.sql](sql/tecnico/Procedimiento_Funciones/Funciones.sql) · [Comparaciones.sql](sql/tecnico/Procedimiento_Funciones/Comparaciones.sql) · [Documentación](sql/tecnico/Procedimiento_Funciones/tema-1-procedimientos-funciones.md) |
| Seguridad y permisos | Roles, usuarios y permisos | [Seguridad_Permisos.sql](sql/tecnico/Seguridad_Permisos/Seguridad_Permisos.sql) · [Investigación](sql/tecnico/Seguridad_Permisos/Investigacion.md) |
| Triggers y auditoría | Triggers de stock en compras y ventas, y auditoría de mermas | [Trigger_StockCompras.sql](sql/tecnico/Trigger_Auditoria/Trigger_StockCompras.sql) · [Trigger_StockVentas.sql](sql/tecnico/Trigger_Auditoria/Trigger_StockVentas.sql) · [Merma_Auditoria.sql](sql/tecnico/Trigger_Auditoria/Merma_Auditoria.sql) · [Investigación](sql/tecnico/Trigger_Auditoria/Investigacion.md) |

## 👥 Integrantes

- Craballo Jara Luciana Abril
- Encinas Priscila Ayelen
- Gonzalez Avril Araceli
- Fernández Zalazar Jeremías Ezequiel
- Belen Chaile

---

<div align="center">

🌿 *Proyecto académico · Base de Datos I · Equipo 15*

</div>
