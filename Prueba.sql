-- Nota: Habilitar salidas del DBMS
SET SERVEROUTPUT ON;
/
--------------------------------------------------------------------------------------------------------------------
-- Punto 4
-- Se genera cons ecuencia para autoincrementable automatico
/
CREATE TABLE Empleados (
    ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50),
    Puesto VARCHAR2(50),
    Salario NUMBER
);
/
INSERT INTO Empleados (ID, NOMBRE, PUESTO, SALARIO) VALUES ('1', 'Juan', 'Armando', 45000);
/
select * from Empleados;
---------------------------------------------------------------------------------------------------------------------
-- Punto 5
/
CREATE OR REPLACE PROCEDURE AumentarSalario (
    p_empleado_id IN NUMBER,
    p_porcentaje_aumento IN NUMBER
) AS
    v_salario_empleado NUMBER;
BEGIN
    BEGIN
        SELECT salario INTO v_salario_empleado FROM Empleados WHERE ID = p_empleado_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_salario_empleado := NULL;
    END;

    IF v_salario_empleado IS NOT NULL THEN
        UPDATE Empleados SET salario = salario * (1 + p_porcentaje_aumento / 100) WHERE ID = p_empleado_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Salario aumentado exitosamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El empleado con ID ' || p_empleado_id || ' no existe');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
-- Ejecutar procedure:
BEGIN
    AumentarSalario(1, 10);
END;
/
select * from Empleados;
--------------------------------------------------------------------------------------------------------------------
-- Punto 6
/
CREATE OR REPLACE FUNCTION CalcularBonificacion(p_salario IN NUMBER)
RETURN NUMBER
IS
    v_bonificacion NUMBER;
BEGIN
    IF p_salario <= 30000 THEN
        v_bonificacion := p_salario * 0.20;
    ELSIF p_salario > 30000 AND p_salario <= 50000 THEN
        v_bonificacion := p_salario * 0.15;
    ELSE
        v_bonificacion := p_salario * 0.10;
    END IF;

    RETURN v_bonificacion;
END CalcularBonificacion;
/
-- Ejecutar Function
DECLARE
    salario_empleado NUMBER := 35000;
    bonificacion NUMBER;
BEGIN
    bonificacion := CalcularBonificacion(salario_empleado);
    DBMS_OUTPUT.PUT_LINE('La bonificación es: ' || bonificacion);
END;
/
--------------------------------------------------------------------------------------------------------------------
-- Punto 7
/
CREATE SEQUENCE sec_empleados START WITH 2 INCREMENT BY 1 NOCACHE NOCYCLE;
/
CREATE OR REPLACE TRIGGER Empleado_BeforeInsert
BEFORE INSERT ON Empleados
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN
        SELECT sec_empleados.NEXTVAL INTO :NEW.ID FROM dual;
    END IF;
END;
/
INSERT INTO Empleados (NOMBRE, PUESTO, SALARIO) VALUES ('Luisa', 'Martinez', 700500);
/
select * from Empleados;
--------------------------------------------------------------------------------------------------------------------
-- Punto 8
/
CREATE TABLE Ventas (
    ID_Venta NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_Empleado NUMBER,
    Descripcion_Venta VARCHAR2(200),
    Valor_Venta NUMBER,
    CONSTRAINT fk_empleado FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID)
);
/
CREATE OR REPLACE TYPE VentaRecord AS OBJECT (
    ID_Venta NUMBER,
    Valor_Venta NUMBER
);
/
CREATE OR REPLACE TYPE VentaTableType AS TABLE OF VentaRecord;
/
CREATE OR REPLACE FUNCTION obtener_ventas_empleado(p_ID_Empleado IN NUMBER)
RETURN VentaTableType PIPELINED
AS
    v_venta_record VentaRecord;
BEGIN
    FOR venta IN (SELECT ID_Venta, Valor_Venta
                  FROM Ventas
                  WHERE ID_Empleado = p_ID_Empleado) 
    LOOP
        v_venta_record := VentaRecord(venta.ID_Venta, venta.Valor_Venta);
        PIPE ROW(v_venta_record);
    END LOOP;

    RETURN;
END obtener_ventas_empleado;
/
insert into ventas(ID_EMPLEADO, DESCRIPCION_VENTA, VALOR_VENTA)
values (1, 'test', '300000');
/
SELECT * FROM TABLE(obtener_ventas_empleado(1));
/
--------------------------------------------------------------------------------------------------------------------
-- Punto 9
SELECT *
FROM Empleados
WHERE Salario BETWEEN 40000 AND 60000;
/
SELECT AVG(Salario) AS SalarioPromedio
FROM Empleados;
/
SELECT COUNT(*) AS NumEmpleados
FROM Empleados
WHERE Salario > 70000;
