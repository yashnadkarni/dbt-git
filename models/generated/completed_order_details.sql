{{ config(materialized='table') }}

with orders as (
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status,
        amount
    from {{ source('jaffle_shop', 'raw_orders') }}
),
customers as (
    select
        id,
        first_name,
        last_name
    from {{ source('jaffle_shop', 'raw_customers') }}
)

select
    o.order_id,
    o.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    o.order_date,
    o.status,
    o.amount / 100.0 as amount_dollars
from orders o
left join customers c on o.customer_id = c.id
where o.status = 'completed'
