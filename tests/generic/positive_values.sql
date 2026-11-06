{% test positive_values(model, column_name, value=0) %}
select {{ column_name }}
from {{ model }}
where {{ column_name }} < {{ value }}
{% endtest %}