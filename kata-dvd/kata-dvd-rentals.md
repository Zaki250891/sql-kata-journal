# Kata Journal

## Kata
**Nombre:** Analyzing Consecutive Days of DVD Rentals for a Customer
**Plataforma:** Codewars
**Nivel:** 4 kyu
**Lenguaje:** PostgreSQL


Objetivo de la Kata
Escribir una consulta SQL sobre la base de datos de alquiler de DVDs para analizar los patrones de alquiler del cliente con customer_id = 1, identificando las rachas o secuencias de días consecutivos en los que realizó alquileres.

Puntos Clave y Requisitos
Filtrado por cliente: La consulta debe enfocarse únicamente en el cliente con customer_id = 1.

Identificar días consecutivos: Debes agrupar las fechas de alquiler en secuencias de días seguidos (por ejemplo, si alquiló el 14, 15 y 16 de febrero, esos días forman un grupo de 3 días consecutivos).

Calcular el tamaño del grupo: Para cada fecha individual, debes calcular cuántos días dura el grupo de días consecutivos al que pertenece. Si un día de alquiler está aislado (sin alquileres el día anterior ni el posterior), el tamaño de su grupo es 1.

Sin duplicados por día: Si el cliente alquiló varias películas el mismo día, esa fecha solo debe aparecer una vez en el resultado y contar como un solo día.

Orden de los resultados: Las fechas deben ordenarse de forma ascendente (de la más antigua a la más reciente).

Columnas del Resultado
La consulta debe devolver exactamente estas tres columnas:

name: El nombre completo del cliente (concatenando first_name y last_name con un espacio).

date_rental_occurred: La fecha del alquiler (únicamente la fecha, sin la parte de la hora).

consecutive_days: El tamaño del grupo de días consecutivos al que pertenece cada fecha (mínimo 1).

**En mis palabras:**
Por cada día que el cliente seleccionado ha rentado una película, debo identificar a que grupo de "rentas consecutivas" pertenece. O sea encontrar secuencias de días en donde cada día es. directamente consecutivo o le sigue otro día (ejemplo: 14, 15, 16 de febrero que forman un grupo de 3 días consecutivos).

Por cada día de renta determinar el tamaño de lso grupos de días consecutivos.

Asegurar que cada fecha aparezca una sola vez en los resultados, si el customer rentó más de una película debe tomarse como como un solo día.

*_RESULTADO ESPERADO: name, date_rental_ocurred, consecutive_days_*

**Importante es iniciar con los CTEs que resuelven las cuestiones de la lógica de negocio y después resolver el formato y presentación de datos, en éste caso específico puede ser CONCAT para first_name + last_name.**