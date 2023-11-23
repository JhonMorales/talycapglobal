# Solucion prueba técnica:
Instrucciones:
• Responde las siguientes preguntas y completa los ejercicios en PL/SQL.
• Por favor, proporciona las respuestas y el código PL/SQL en un archivo de texto o en el formato que prefieras(este formato incluye la opción de realizar los ejercicios en cualquier entorno de desarrollo o herramienta).

Preguntas teóricas:
1. ¿Qué es PL/SQL y cuál es su propósito en el desarrollo de aplicaciones?
**Respuesta = Facilitar la interaccion con la base de datos y permite gran manejo de logica de negocio y procesamiento de los datos (Triggers, Procedimientos, Procedures, Transactions)**
2. Explique la diferencia entre un procedimiento almacenado y una función en PL/SQL.
**Respeusta = Una función retorna un valor, un procedimiento no, la función maneja excepciones y en caso de error debemos devolver un valor**
3. ¿Qué es una excepción en PL/SQL y cómo se manejan?
**Respuesta = Pueden ser errores internos, errores de usuario o condiciones no controladas, estas interrumpen el flujo normal. Se pueden manejar con "Exception"**
```sql
DECLARE
    -- Declaración de variables
BEGIN
    -- Código principal
    
EXCEPTION
    WHEN exception1 THEN
        -- Manejo específico para la excepción1
    WHEN exception2 THEN
        -- Manejo específico para la excepción2
    WHEN OTHERS THEN
        -- Manejo para cualquier otra excepción no especificada
END;
```
Los demas puntos practicos estan en el archivo **Prueba.sql**