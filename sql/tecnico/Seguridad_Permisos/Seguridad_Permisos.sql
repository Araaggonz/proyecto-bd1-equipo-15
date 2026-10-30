/* =============================
ETAPA V - TEMA SEGURIDAD 
Manejo de permisos a nivel de usuarios y roles en SQL Server
================================== */ 
USE VERDE_ENCANTO; 

/* ================================
CREACION DE LOGINS (nivel servidor) 
=================================== */ 
USE master; 
GO 

CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*'; 
CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector123*'; 
CREATE LOGIN usuario_con_rol WITH PASSWORD = 'ConRol123*'; 
CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'SinRol123*';

GO 

/* =============================
CREACION DE USUARIOS (nivel bases de datos)
============================================ */ 

USE VERDE_ENCANTO;

GO 

CREATE USER usuario_admin FOR LOGIN usuario_admin; 
CREATE USER usuario_lector   FOR LOGIN usuario_lector;
CREATE USER usuario_con_rol  FOR LOGIN usuario_con_rol;
CREATE USER usuario_sin_rol  FOR LOGIN usuario_sin_rol;

GO

/* =====================================================================
   PROCEDIMIENTO ALMACENADO USADO EN LA DEMOSTRACION
   Registra una venta (y su comprobante) en una sola operacion.
   ===================================================================== */

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaSimple
    @id_cliente  INT,
    @id_vendedor INT,
    @id_metodo   INT,
    @total       DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @id_comprobante INT, @numero INT, @id_venta INT;
 
    BEGIN TRY
        BEGIN TRANSACTION;
 
        -- Como los id no son IDENTITY, se calcula el siguiente disponible
        SELECT @id_comprobante = ISNULL(MAX(id_comprobante), 0) + 1,
               @numero         = ISNULL(MAX(numero), 1000) + 1
        FROM Comprobante WITH (UPDLOCK, HOLDLOCK);
 
        SELECT @id_venta = ISNULL(MAX(id_venta), 0) + 1
        FROM Venta WITH (UPDLOCK, HOLDLOCK);
 
        INSERT INTO Comprobante (id_comprobante, numero, fecha, estado_)
        VALUES (@id_comprobante, @numero, CAST(GETDATE() AS DATE), 'Pendiente');
 
        INSERT INTO Venta (id_venta, fecha_, total, id_metodo, id_comprobante, id_cliente, id_vendedor)
        VALUES (@id_venta, CAST(GETDATE() AS DATE), @total, @id_metodo, @id_comprobante, @id_cliente, @id_vendedor);
 
        COMMIT TRANSACTION;
 
        SELECT @id_venta AS id_venta_registrada;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
 
 
/* =====================================
    PERMISOS A NIVEL DE USUARIOS
   ==================================== */
 
 -- Usuario administrador: miembro del rol db_owner
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GO
 
-- Usuario lector: solo puede consultar la tabla Venta
GRANT SELECT ON dbo.Venta TO usuario_lector;
GO
 
-- Aunque solo lee, puede ejecutar el procedimiento autorizado
GRANT EXECUTE ON dbo.sp_RegistrarVentaSimple TO usuario_lector;
GO


/* ---------------------------------------------------------------------
   PRUEBAS DE LA PARTE 1
   EXECUTE AS USER permite probar cada usuario sin cambiar de conexion.
   REVERT vuelve al usuario original.
   --------------------------------------------------------------------- */
 
-- Prueba 1.A: INSERT directo con usuario_admin (esperado: CORRECTO)
EXECUTE AS USER = 'usuario_admin';
    SELECT USER_NAME() AS usuario_actual;
 
    INSERT INTO Comprobante (id_comprobante, numero, fecha, estado_)
    VALUES (100, 9001, CAST(GETDATE() AS DATE), 'Pendiente');
 
    INSERT INTO Venta (id_venta, fecha_, total, id_metodo, id_comprobante, id_cliente, id_vendedor)
    VALUES (100, CAST(GETDATE() AS DATE), 15000, 1, 100, 1, 1);
 
    PRINT 'usuario_admin: INSERT directo sobre Venta CORRECTO';
REVERT;
GO
 
-- Prueba 1.B: INSERT directo con usuario_lector (esperado: ACCESO DENEGADO)
EXECUTE AS USER = 'usuario_lector';
    SELECT USER_NAME() AS usuario_actual;
    BEGIN TRY
        INSERT INTO Venta (id_venta, fecha_, total, id_metodo, id_comprobante, id_cliente, id_vendedor)
        VALUES (101, CAST(GETDATE() AS DATE), 15000, 1, 100, 1, 1);
 
        PRINT 'usuario_lector: INSERT permitido (NO ESPERADO)';
    END TRY
    BEGIN CATCH
        PRINT 'usuario_lector: INSERT directo DENEGADO -> ' + ERROR_MESSAGE();
    END CATCH
REVERT;
GO
 
-- Prueba 1.C: el lector SI puede consultar Venta (permiso SELECT)
EXECUTE AS USER = 'usuario_lector';
    SELECT TOP (5) * FROM Venta ORDER BY id_venta DESC;
REVERT;
GO


-- Prueba 2: INSERT mediante el procedimiento con usuario_lector (esperado: CORRECTO)
EXECUTE AS USER = 'usuario_lector';
    SELECT USER_NAME() AS usuario_actual;
    EXEC dbo.sp_RegistrarVentaSimple
         @id_cliente  = 1,
         @id_vendedor = 1,
         @id_metodo   = 1,
         @total       = 15000;
REVERT;
GO
 
-- Verificar que la venta quedo registrada
SELECT TOP (5) id_venta, fecha_, total, id_cliente, id_vendedor
FROM Venta
ORDER BY id_venta DESC;
GO


/* ==============================
   PERMISOS A NIVEL DE ROLES
   ============================= */
 
-- Rol personalizado para consultar productos
CREATE ROLE rol_consulta_productos;
GO
 
-- Permiso asignado al ROL (no a cada usuario)
GRANT SELECT ON dbo.Producto TO rol_consulta_productos;
GO
 
-- Solo usuario_con_rol se incorpora al rol
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
GO



/* -----------------
       PRUEBAS 
   ------------------ */
 
-- Prueba 3: SELECT sobre Producto con usuario_con_rol (esperado: CORRECTO)
EXECUTE AS USER = 'usuario_con_rol';
    SELECT USER_NAME() AS usuario_actual;
    SELECT id_producto, nombre, stock_actual FROM Producto;
REVERT;
GO
 
-- Prueba 4: SELECT sobre Producto con usuario_sin_rol (esperado: ACCESO DENEGADO)
EXECUTE AS USER = 'usuario_sin_rol';
    SELECT USER_NAME() AS usuario_actual;
    BEGIN TRY
        SELECT id_producto, nombre, stock_actual FROM Producto;
        PRINT 'usuario_sin_rol: SELECT permitido (NO ESPERADO)';
    END TRY
    BEGIN CATCH
        PRINT 'usuario_sin_rol: SELECT DENEGADO -> ' + ERROR_MESSAGE();
    END CATCH
REVERT;
GO
