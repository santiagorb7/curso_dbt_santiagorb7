{% docs stock_status %}
Categorización del stock a partir de `inventory_units`.

| stock_status | Regla                                        |
|--------------|----------------------------------------------|
| out_of_stock | inventory_units = 0                          |
| low_stock    | 0 < inventory_units < umbral (10 por defecto) |
| in_stock     | inventory_units >= umbral                    |

Desde el día 6, el umbral es la variable de proyecto `low_stock_threshold`.
{% enddocs %}
