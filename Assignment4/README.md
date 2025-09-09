# 🍜 Danny's Diner SQL Case Study

## 📋 Description

The schema contains three interconnected tables: `sales`, `menu`, and `members`.


## 🗃️ Database Structure

- **sales**  
  Tracks each customer's purchase history with columns:
  - `customer_id`
  - `order_date`
  - `product_id`

- **menu**  
  Describes the items available for sale:
  - `product_id`
  - `product_name`
  - `price`

- **members**  
  Records which customers joined the loyalty program and when:
  - `customer_id`
  - `join_date`

---

## ✅ What I Learned

- **Basic SQL Queries**: Selecting, filtering, and sorting rows.
- **JOINs**: Using `INNER JOIN` to combine tables based on keys.
- **Aggregations**: Calculating totals and counts using `SUM()`, `COUNT()`.
- **Grouping & Filtering**: Applying `GROUP BY` and `HAVING` for grouped conditions.
- **Window Functions**: Using `ROW_NUMBER()` and `RANK()` to identify first/most recent purchases.
- **CASE Statements**: Applying conditional logic for calculating points.
- **Subqueries**: Writing nested queries for more complex filtering.
- **Date Functions**: Using `BETWEEN`, `DATE_ADD` to work with date ranges.
