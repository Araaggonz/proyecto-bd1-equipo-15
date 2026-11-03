/* =====================================================================
   ETAPA V - TEMA OPTIMIZACION DE CONSULTAS A TRAVES DE INDICES
   Base de datos: VERDE_ENCANTO
   ---------------------------------------------------------------------
   Se usa una tabla de pruebas aparte (VentaHistorica) y no la tabla
   Venta real, por dos motivos:
   1) Venta ya tiene un indice agrupado (por su PRIMARY KEY), asi que no
      se podria crear otro agrupado sobre la fecha.
   2) Hace falta un millon de registros, y no queremos ensuciar las
      tablas reales del sistema.
   La tabla replica el caso de negocio: analizar ventas por periodo.

   Recomendacion: en SSMS activar "Include Actual Execution Plan"
   (Ctrl + M) antes de ejecutar cada consulta, para sacar la captura
   del plan de ejecucion.
   ===================================================================== */

USE VERDE_ENCANTO;
GO


/* =====================================================================
   PARTE 1 - CREACION DE LA TABLA DE PRUEBAS
   Se crea SIN clave primaria ni indices (tabla "heap"), a proposito:
   es el punto de partida para medir la consulta sin optimizar.
   ===================================================================== */

  CREATE TABLE dbo.VentaHistorica
(
    id_venta    BIGINT IDENTITY(1,1),
    fecha_venta DATE NOT NULL,
    importe     DECIMAL(12,2) NOT NULL
);
GO


/* =====================================================================
   PARTE 2 - CARGA MASIVA DE DATOS (1.000.000 de registros)
   Fechas aleatorias entre 2020-01-01 y ~2024-12-31
   e importes aleatorios entre 0 y 10.000.
   Puede tardar unos segundos o un par de minutos segun la maquina.
   ===================================================================== */
SET NOCOUNT ON;
GO

WITH Numeros AS
(
    SELECT TOP (1000000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO dbo.VentaHistorica (fecha_venta, importe)
SELECT
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1825, '2020-01-01'),
    RAND(CHECKSUM(NEWID())) * 10000
FROM Numeros;
GO

-- Verificar la cantidad de registros
SELECT COUNT(*) AS CantidadRegistros
FROM dbo.VentaHistorica;
GO


/* =====================================================================
   PARTE 3 - CONSULTA SIN INDICES  (escenario 1)
   Se espera un Table Scan: el motor lee toda la tabla.
   Registrar en el informe: tiempo de CPU, tiempo total,
   lecturas logicas, operacion principal y captura del plan.
   ===================================================================== */
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT
    id_venta,
    fecha_venta,
    importe
FROM dbo.VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO

-- Tamano de la tabla sin indices (para comparar el costo en espacio)
EXEC sp_spaceused 'dbo.VentaHistorica';
GO


/* =====================================================================
   PARTE 4 - INDICE AGRUPADO SOBRE LA FECHA  (escenario 2)
   Un indice agrupado ordena fisicamente la tabla por la columna elegida
   Se espera un Clustered Index Seek.
   ===================================================================== */

CREATE CLUSTERED INDEX IX_VentaHistorica_Fecha
ON dbo.VentaHistorica (fecha_venta);
GO

SELECT
    id_venta,
    fecha_venta,
    importe
FROM dbo.VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO

EXEC sp_spaceused 'dbo.VentaHistorica';
GO


/* =====================================================================
   PARTE 5 - ELIMINAR EL INDICE AGRUPADO
   La tabla vuelve a ser un heap, para probar el siguiente escenario
   en igualdad de condiciones.
   ===================================================================== */
DROP INDEX IX_VentaHistorica_Fecha
ON dbo.VentaHistorica;
GO


/* =====================================================================
   PARTE 6 - INDICE CON COBERTURA  (escenario 3)
   Indice no agrupado sobre la fecha que INCLUYE el importe: la consulta
   se resuelve leyendo solo el indice, sin ir a la tabla.
   Se espera un Index Seek con las menores lecturas logicas.
   ===================================================================== */
CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_Cobertura
ON dbo.VentaHistorica (fecha_venta)
INCLUDE (importe);
GO

SELECT
    fecha_venta,
    importe
FROM dbo.VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO

EXEC sp_spaceused 'dbo.VentaHistorica';
GO


/* =====================================================================
   PARTE 7 (EXTRA) - CASO DE NEGOCIO CON EL INDICE DE COBERTURA
   Total vendido en el primer trimestre de 2023. La consulta tambien
   queda cubierta por el indice (solo usa fecha_venta e importe).
   ===================================================================== */
SELECT
    COUNT(*)     AS cantidad_ventas,
    SUM(importe) AS total_vendido
FROM dbo.VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO


/* =====================================================================
   PARTE 8 (EXTRA) - COSTO DE MANTENER EL INDICE
   Los indices aceleran las lecturas pero cuestan espacio y hacen un
   poco mas lentos los INSERT/UPDATE/DELETE. Se puede mostrar el espacio
   con sp_spaceused (ya ejecutado arriba) y este detalle por indice:
   ===================================================================== */
SELECT
    i.name                         AS indice,
    i.type_desc                    AS tipo,
    SUM(ps.used_page_count) * 8    AS espacio_usado_kb
FROM sys.indexes i
JOIN sys.dm_db_partition_stats ps
     ON i.object_id = ps.object_id AND i.index_id = ps.index_id
WHERE i.object_id = OBJECT_ID('dbo.VentaHistorica')
GROUP BY i.name, i.type_desc;
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
