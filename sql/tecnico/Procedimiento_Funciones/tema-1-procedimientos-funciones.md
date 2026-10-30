# Etapa V: Implementación de Temas Técnicos
## Tema 1: Procedimientos y Funciones Almacenadas

**Proyecto:** Sistema de Gestión Comercial -- Vivero **Verde Encanto**  
**Equipo:** 15  
**Integrante:** Encinas Priscila  

---

## 1. Introducción y Objetivos
En esta sección se documenta la implementación de **Procedimientos Almacenados (Stored Procedures)** y **Funciones Definidas por el Usuario (UDF)** en el motor **SQL Server Express**, orientados a optimizar la gestión de datos, centralizar reglas de negocio y garantizar la integridad transaccional en el sistema del vivero **VERDE_ENCANTO**.

---

## 2. Procedimientos Almacenados (Stored Procedures)

Los procedimientos almacenados permiten encapsular lógica transaccional compleja directamente en el servidor de base de datos. Para el mantenimiento del catálogo de productos, se desarrollaron procedimientos específicos que operan sobre la tabla `Producto`.

### 2.1. Inserción de Productos (`sp_InsertarProducto`)
Este procedimiento permite registrar un nuevo producto validando los campos obligatorios y respetando las restricciones de stock y estado del sistema.

```sql
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
GO