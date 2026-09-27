# SQL Online Store Analytics (MySQL)

A small SQL project analyzing sales data for a fictional online store.

## Database schema

- `customers(customer_id, customer_name, city)`
- `products(product_id, product_name, category, price)`
- `orders(order_id, customer_id, order_date)`
- `order_items(order_item_id, order_id, product_id, quantity, price_per_unit)`

## Files

- `schema.sql` – CREATE TABLE statements (MySQL).
- `data.sql` – Sample INSERT statements.
- `queries.sql` – Analysis queries:
  - Orders with customer names and order totals.
  - Total spending per customer and customer segmentation.
  - Second highest spender and top N customers using window functions.
  - Top 2 orders per customer.
  - Monthly sales and running totals.

## How to run

1. Create a MySQL database, e.g. `online_store`.
2. Run `schema.sql`.
3. Run `data.sql`.
4. Run queries from `queries.sql`.
