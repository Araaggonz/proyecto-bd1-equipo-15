# Documentacion de Seguridad - etapa 5

## 1. Introducción

En la base de datos `VERDE_ENCANTO`, correspondiente al sistema de gestión comercial de un vivero, se implementó un esquema de seguridad basado en usuarios, roles y permisos, con el fin de controlar quién puede acceder a la información y qué operaciones puede realizar cada perfil.

Los elementos desarrollados son:

* Cuatro logins y sus usuarios: `usuario_admin`, `usuario_lector`, `usuario_con_rol` y `usuario_sin_rol`.
* El procedimiento almacenado `sp_RegistrarVentaSimple`.
* Permisos asignados directamente a usuarios.
* El rol personalizado `rol_consulta_productos`, con permisos asignados a nivel de rol.

El script completo y las capturas de las pruebas se encuentran en [`sql/tecnico/Seguridad_Permisos`](../../sql/tecnico/Seguridad_Permisos/).

## 2. Logins y usuarios

**Nombres:** `usuario_admin`, `usuario_lector`, `usuario_con_rol`, `usuario_sin_rol`
**Nivel:** login (servidor) y usuario (base de datos `VERDE_ENCANTO`)

### Objetivo

Contar con identidades distintas para representar los diferentes perfiles que acceden al sistema del vivero y poder asignarles permisos diferenciados.

### Funcionamiento

Primero se crea un login por cada perfil a nivel de servidor, y luego un usuario asociado a ese login dentro de la base de datos. Los permisos se otorgan sobre el usuario o sobre un rol al que pertenece.

Para crear logins propios de SQL Server, la instancia debe tener habilitada la autenticación mixta (*SQL Server and Windows Authentication mode*) y reiniciarse el servicio. Las contraseñas del script son credenciales de prueba, usadas solo para la demostración.

| Perfil en el vivero | Usuario | Función en la demostración |
|---|---|---|
| Dueño / administrador | `usuario_admin` | Control total de la base de datos |
| Vendedor de mostrador | `usuario_lector` | Consulta ventas y registra ventas mediante el procedimiento |
| Personal de consulta de stock | `usuario_con_rol` | Consulta productos a través de un rol |
| Personal sin autorización sobre productos | `usuario_sin_rol` | Sin permisos, sirve de contraste |

## 3. Procedimiento almacenado de registro de ventas

**Nombre:** `sp_RegistrarVentaSimple`
**Esquema:** `dbo`
**Tablas involucradas:** `Comprobante` y `Venta`
**Parámetros:** `@id_cliente`, `@id_vendedor`, `@id_metodo` y `@total`.

### Objetivo

Permitir registrar una venta completa mediante una única operación controlada, de modo que un usuario pueda realizarla sin necesitar permisos de escritura directos sobre las tablas.

### Funcionamiento

El procedimiento calcula el siguiente identificador disponible de comprobante y de venta (los identificadores no son `IDENTITY`), inserta el comprobante en estado `Pendiente` y luego inserta la venta asociada, con la fecha del día. Todo se ejecuta dentro de una transacción: si alguna instrucción falla, se realiza un `ROLLBACK` y se informa el error, de modo que no queda un comprobante sin venta.

Como el procedimiento y las tablas pertenecen al mismo propietario (`dbo`), SQL Server aplica el encadenamiento de propiedad (*ownership chaining*): al ejecutar el procedimiento solo verifica el permiso `EXECUTE`, y no vuelve a verificar los permisos sobre las tablas que utiliza internamente.

### Pruebas realizadas

Se ejecutó el procedimiento con `usuario_lector`, que no tiene permiso de inserción sobre `Venta`. La venta se registró correctamente y el procedimiento devolvió el identificador generado. Una consulta posterior a la tabla `Venta` confirmó que el registro había quedado guardado.

## 4. Permisos a nivel de usuarios

**Usuarios:** `usuario_admin` y `usuario_lector`
**Sentencias utilizadas:** `ALTER ROLE ... ADD MEMBER` y `GRANT`.

### Objetivo

Demostrar cómo se asignan permisos de forma individual, aplicando el principio de mínimo privilegio: cada usuario recibe solo lo necesario para su función.

### Funcionamiento

* `usuario_admin` se agregó al rol fijo `db_owner`, por lo que puede realizar cualquier operación en la base de datos.
* `usuario_lector` recibió únicamente `SELECT` sobre la tabla `Venta` y `EXECUTE` sobre `sp_RegistrarVentaSimple`.

De esta forma, el vendedor puede consultar las ventas y registrar nuevas mediante el procedimiento, pero no puede insertar, modificar ni eliminar filas de `Venta` de forma directa.

### Pruebas realizadas

Las pruebas se hicieron con `EXECUTE AS USER`, que permite asumir la identidad de cada usuario desde una misma ventana de consulta (`REVERT` vuelve al usuario original). Los casos que debían fallar se ejecutaron dentro de un bloque `TRY...CATCH` para mostrar el mensaje de error del motor.

Se probó un `INSERT` directo sobre `Venta` con `usuario_admin` y con `usuario_lector`. Con `usuario_admin` la operación se ejecutó correctamente. Con `usuario_lector` SQL Server la rechazó con el error 229: *"The INSERT permission was denied on the object 'Venta', database 'VERDE_ENCANTO', schema 'dbo'."*

## 5. Permisos a nivel de roles

**Nombre del rol:** `rol_consulta_productos`
**Tabla asociada:** `Producto`
**Permiso:** `SELECT`.

### Objetivo

Centralizar la administración de permisos: el permiso se define una sola vez en el rol y lo reciben todos sus miembros.

### Funcionamiento

Se creó el rol `rol_consulta_productos` y se le otorgó `SELECT` sobre `Producto`. Luego se agregó únicamente a `usuario_con_rol` como miembro. `usuario_sin_rol` no pertenece al rol ni tiene permisos propios sobre la tabla.

### Pruebas realizadas

Se ejecutó un `SELECT` sobre `Producto` con ambos usuarios. Con `usuario_con_rol` la consulta devolvió los productos. Con `usuario_sin_rol` SQL Server denegó el acceso con el error 229: *"The SELECT permission was denied on the object 'Producto', database 'VERDE_ENCANTO', schema 'dbo'."*

## 6. Resumen de pruebas

| Prueba | Usuario | Resultado esperado | Resultado obtenido |
|---|---|---|---|
| `INSERT` directo sobre `Venta` | `usuario_admin` | Correcto | Correcto |
| `INSERT` directo sobre `Venta` | `usuario_lector` | Acceso denegado | Acceso denegado |
| `EXEC sp_RegistrarVentaSimple` | `usuario_lector` | Correcto | Correcto |
| `SELECT` sobre `Producto` | `usuario_con_rol` | Correcto | Correcto |
| `SELECT` sobre `Producto` | `usuario_sin_rol` | Acceso denegado | Acceso denegado |

Las capturas de cada prueba están en la carpeta [`Evidencias`](../../sql/tecnico/Seguridad_Permisos/Evidencias/) y el desarrollo teórico en [`Investigacion.md`](../../sql/tecnico/Seguridad_Permisos/Investigacion.md).

## 7. Conclusiones

A partir de las pruebas realizadas, se comprobó el funcionamiento del esquema de seguridad implementado en la base de datos `VERDE_ENCANTO`.

Los permisos asignados a nivel de usuario permitieron diferenciar lo que puede hacer cada perfil: `usuario_admin` pudo operar libremente sobre las tablas, mientras que `usuario_lector` pudo consultar `Venta` pero no insertar en ella de forma directa. El rol `rol_consulta_productos` permitió otorgar el acceso a `Producto` una sola vez y que lo recibiera únicamente quien pertenece al rol.

El procedimiento `sp_RegistrarVentaSimple` mostró que es posible autorizar una operación puntual, como registrar una venta, sin dar acceso de escritura directo a las tablas, manteniendo la lógica de negocio en un único lugar y protegida por una transacción.

En conclusión, el uso de usuarios, roles, permisos y procedimientos almacenados contribuye a mejorar la seguridad, la integridad y el control de los datos del sistema comercial del vivero, aplicando el principio de mínimo privilegio y reduciendo el riesgo de modificaciones no autorizadas.
