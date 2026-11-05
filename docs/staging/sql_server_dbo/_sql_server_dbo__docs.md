{% docs order_status %}
Estado del pedido.

| order_status | Significado                               |
|--------------|-------------------------------------------|
| preparing    | Pedido recibido y en preparación          |
| shipped      | Pedido enviado, pendiente de entrega      |
| delivered    | Pedido entregado al cliente               |
{% enddocs %}

{% docs promo_status %}
Estado de la promoción: `active` si se puede aplicar a pedidos nuevos,
`inactive` si ya no.
{% enddocs %}

{% docs event_type %}
Tipo de evento de navegación.

| event_type      | Significado                                 |
|-----------------|---------------------------------------------|
| page_view       | El usuario ha visitado una página           |
| add_to_cart     | El usuario ha añadido un producto al carrito|
| checkout        | El usuario ha finalizado un pedido          |
| package_shipped | Se ha registrado el envío del pedido        |

Los eventos `checkout` y `package_shipped` llevan `order_id`; `add_to_cart`
lleva `product_id`.
{% enddocs %}
