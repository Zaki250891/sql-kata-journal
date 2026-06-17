__La misión:__ *recuperar la cadena enorme XML como filas y columnas separadas.*

__Notas:__ 
1) *El campo private determina si la dirección de correo electrónico del usuario debe ser visible públicamente; Si el perfil es privado __(private)__, email_address debe ser igual a __(Hidden)__*

2) *Los usuarios pueden tener múltiples direcciones de correo electrónico; si hay múltiples direcciones de correo electrónico, se debe mostrar la primera.*

3) *Si no se proporcionan direcciones de correo electrónico, email_address debe ser igual a __(None)__.*

4) *El campo __date_of_birth__ está en el formato __aaaa-mm-dd__.*

5) *El campo age (edad) representa la edad del usuario en años.*

**P.S. ORDENAR el resultado por las columnas *first_name* y *last_name*.**

_DATOS RAW_ (users)
Tabla de entrada (Input table)
| Tabla | Columna | Tipo |
|-------+--------+------|
| users | id     | int  |
|       | data   | xml  |
Formato XML (XML format)
XML

<data>
    <user>
        <first_name>...</first_name>
        <last_name>...</last_name>
        <date_of_birth>...</date_of_birth>
        <private>...</private>
        <email_addresses>
            <address>...</address>
            <address>...</address>
            ...
            <address>...</address>
        </email_addresses>
    </user>
    <user>...</user>
    ...
    <user>...</user>
</data>

_OUTPUT ESPERADO_

Tabla de salida (Output table)
|    Columna    | Tipo |
|---------------+------|
| first_name    | text |
| last_name     | text |
| age           | int  |
| email_address | text |

__-------------------------------__

¿Big string =/ CONCAT?

**Función para arreglo de NODOS:**
xpath()
xpath('expresión_xpath', columna_xml)

**Función que convierte un arreglo en varias filas:**
unnest()



