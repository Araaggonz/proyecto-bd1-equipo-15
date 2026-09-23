# Etapa 2 – Diseño relacional

## 1. Integrantes: Fernandez Zalazar Jeremias y Gonzalez Avril Araceli 

## 2. Descripción del modelo relacional

El modelo relacional traduce las entidades, atributos y relaciones definidas en la etapa conceptual a un conjunto de tablas, aplicando las reglas de pasaje de modelo entidad-relación a modelo relacional:

- Cada *entidad fuerte* se convierte en una tabla.
- Cada *relación 1:N* se resuelve agregando una clave foránea en la tabla del lado "N".
- Cada *relación N:M* se resuelve mediante una tabla intermedia (asociativa) que contiene las claves primarias de ambas entidades participantes, más los atributos propios de la relación.

El supertipo PERSONA y sus subtipos CLIENTE, VENDEDOR y PROVEEDOR se mantuvieron como tablas separadas, vinculadas entre sí mediante el DNI, respetando el mismo criterio de especialización definido en el diseño conceptual.

---

## 3. Tablas resultantes y sus atributos

### 3.1 PERSONA

| Atributo | Tipo de clave |
|---|---|
| DNI | PK |
| Nombre | |
| Apellido | |
| Telefono | (U) |
| Correo_Electronico | (U) |

Concentra los datos comunes a los tres roles (cliente, vendedor, proveedor).

### 3.2 CLIENTE

| Atributo | Tipo de clave |
|---|---|
| DNI | PK, FK → PERSONA |
| Id_Cliente | (U) |

### 3.3 VENDEDOR

| Atributo | Tipo de clave |
|---|---|
| DNI | PK, FK → PERSONA |
| Id_Vendedor | (U) |

### 3.4 PROVEEDOR

| Atributo | Tipo de clave |
|---|---|
| DNI | PK, FK → PERSONA |
| Id_Proveedor | (U) |
| Direccion | |

### 3.5 PRODUCTO

| Atributo | Tipo de clave |
|---|---|
| Id_Producto | PK |
| Stock_Actual | |
| Descripcion | |
| Nombre | |
| Id_Categoria | FK → CATEGORIA |

### 3.6 CATEGORIA

| Atributo | Tipo de clave |
|---|---|
| Id_Categoria | PK |
| Nombre | |
| Descripcion | |

### 3.7 METODO_PAGO

| Atributo | Tipo de clave |
|---|---|
| Id_Metodo | PK |
| Tipo_Metodo | |

### 3.8 VENTA

| Atributo | Tipo de clave |
|---|---|
| Id_Venta | PK |
| Fecha | |
| Total | |
| Id_Metodo | FK → METODO_PAGO |
| DNI | FK → CLIENTE |
| DNI | FK → VENDEDOR |

Concentra dos referencias a persona porque la venta necesita registrar tanto quién compró como quién la vendió.

### 3.9 COMPRA

| Atributo | Tipo de clave |
|---|---|
| Id_Compra | PK |
| Total | |
| Fecha | |
| DNI | FK → VENDEDOR |
| DNI | FK → PROVEEDOR |

### 3.10 PRODUCTO-VENTA (tabla asociativa)

| Atributo | Tipo de clave |
|---|---|
| Id_Venta | PK, FK → VENTA |
| Id_Producto | PK, FK → PRODUCTO |
| Precio_Unitario | |
| Cantidad | |

### 3.11 PRODUCTO-COMPRA (tabla asociativa)

| Atributo | Tipo de clave |
|---|---|
| Id_Producto | PK, FK → PRODUCTO |
| Id_Compra | PK, FK → COMPRA |
| Precio_Unitario | |
| Cantidad | |


## 4. Claves primarias

Cada tabla conserva como clave primaria el mismo identificador definido para su entidad en el modelo conceptual (Id_Venta, Id_Compra, Id_Producto, Id_Categoria, Id_Metodo).

En PERSONA y sus subtipos se usa el DNI como clave primaria, propagado por herencia a CLIENTE, VENDEDOR y PROVEEDOR.

En las tablas asociativas PRODUCTO-VENTA y PRODUCTO-COMPRA la clave primaria es *compuesta*, formada por las dos claves foráneas que identifican cada línea de detalle.

---

## 5. Claves foráneas y relaciones

- *PRODUCTO → CATEGORIA*: cada producto referencia una única categoría.
- *VENTA → METODO_PAGO, VENTA → CLIENTE, VENTA → VENDEDOR: reflejan las relaciones 1:N *"tiene", "realiza" y "registra" del modelo conceptual; la clave foránea queda del lado de VENTA porque era la entidad del lado (0,N)/(1,1).
- *COMPRA → VENDEDOR, COMPRA → PROVEEDOR*: mismo criterio que en VENTA.
- *CLIENTE, VENDEDOR, PROVEEDOR → PERSONA*: relación de especialización, resuelta con el DNI como clave primaria y foránea a la vez.
- *PRODUCTO-VENTA y PRODUCTO-COMPRA: transforman las relaciones N:M *"contiene" (Venta–Producto y Compra–Producto) en tablas propias, ya que una relación de muchos a muchos no puede resolverse solo con claves foráneas en las tablas originales.

---

## 6. Elementos especiales del pasaje de conceptual a relacional

### 6.1 Resolución de relaciones N:M

Las relaciones VENTA–PRODUCTO y COMPRA–PRODUCTO, al ser (1,N)–(0,N), se transformaron en tablas intermedias (PRODUCTO-VENTA y PRODUCTO-COMPRA) que heredan los atributos propios de la relación, como Cantidad y Precio_Unitario, este último usado para conservar el precio histórico de cada operación.

### 6.2 Especialización con clave compartida

En lugar de que cada subtipo tenga su propio identificador independiente, CLIENTE, VENDEDOR y PROVEEDOR comparten el DNI como PK/FK hacia PERSONA, evitando duplicar nombre, apellido, teléfono y correo.

### 6.3 Entidades no incorporadas al modelo relacional

Se observa que MERMA y COMPROBANTE, presentes en el modelo conceptual, no aparecen en este diagrama relacional. Esto podría deberse a que la relación Venta–Comprobante quedó "por definir" en la etapa conceptual, o a una decisión posterior del grupo de dejarlas pendientes para una siguiente iteración.

### 6.4 Atributo derivado no almacenado

El atributo Total de VENTA y COMPRA sigue figurando como columna en la tabla, aunque conceptualmente es derivado (se podría calcular sumando los subtotales de PRODUCTO-VENTA o PRODUCTO-COMPRA); su inclusión física responde probablemente a una decisión de rendimiento, para no recalcularlo en cada consulta.

---

## 7. Diagrama relacional

<img width="1600" height="716" alt="diagrama relacional" src="https://github.com/user-attachments/assets/f34db0b9-42ff-45e1-80c5-7f255505d475" />




---

## 8. Trabajo realizado por cada integrante

Integrante 1 - Avril: participación en el diseño de las tablas, definición de atributos y determinación de claves primarias y foráneas de cada entidad.
