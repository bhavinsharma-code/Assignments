members
+-------------+------------+
| customer_id | join_date  |
+-------------+------------+
| A           | 2021-01-07 |
| B           | 2021-01-09 |
+-------------+------------+

sales
+-------------+------------+------------+
| customer_id | order_date | product_id |
+-------------+------------+------------+
| A           | 2021-01-01 |          1 |
| A           | 2021-01-01 |          2 |
| A           | 2021-01-07 |          2 |
| A           | 2021-01-10 |          3 |
| A           | 2021-01-11 |          3 |
| A           | 2021-01-11 |          3 |
| B           | 2021-01-01 |          2 |
| B           | 2021-01-02 |          2 |
| B           | 2021-01-04 |          1 |
| B           | 2021-01-11 |          1 |
| B           | 2021-01-16 |          3 |
| B           | 2021-02-01 |          3 |
| C           | 2021-01-01 |          3 |
| C           | 2021-01-01 |          3 |
| C           | 2021-01-07 |          3 |
+-------------+------------+------------+

menu
+------------+--------------+-------+
| product_id | product_name | price |
+------------+--------------+-------+
|          1 | sushi        |    10 |
|          2 | curry        |    15 |
|          3 | ramen        |    12 |
+------------+--------------+-------+


-- 1. What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(m.price) as total_amount
    -> from sales as s 
    -> join menu as m on s.product_id = m.product_id
    -> group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) as times_visited
    -> from sales
    -> group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
select customer_id, product_id
    -> from sales s
    -> where order_date = (
    -> select min(order_date)
    -> from sales
    -> where customer_id = s.customer_id
    -> );

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_id, count(*) as times_ordered
    -> from sales
    -> group by product_id
    -> order by times_ordered desc
    -> limit 1;

-- 5. Which item was the most popular for each customer?
with cte as (
    -> select customer_id, product_id, count(*) as times_ordered,
    -> rank() over (partition by customer_id order by count(*) desc) as ranking 
    -> from sales
    -> group by customer_id, product_id)
    -> select customer_id, product_id, times_ordered
    -> from cte
    -> where ranking = 1;

-- 6. Which item was purchased first by the customer after they became a member?
with cte as (
    -> select s.customer_id, s.product_id, s.order_date,
    -> row_number() over (partition by s.customer_id order by s.order_date) as rn
    -> from sales s
    -> join members m on s.customer_id = m.customer_id
    -> where s.order_date >= m.join_date)
    -> select customer_id, product_id
    -> from cte
    -> where rn = 1;
    
-- 7. Which item was purchased just before the customer became a member?
with cte as (
    -> select s.customer_id, s.product_id, s.order_date,
    -> row_number() over (partition by s.customer_id order by s.order_date desc) as rn
    -> from sales s
    -> join members m on s.customer_id = m.customer_id
    -> where s.order_date < m.join_date)
    -> select customer_id, product_id
    -> from cte
    -> where rn = 1;
    
-- 8. What is the total items and amount spent for each member before they became a member?
select s.customer_id, count(*) as total_items, sum(mu.price) as total_amount
    -> from sales s
    -> join members m on s.customer_id = m.customer_id
    -> join menu mu on s.product_id = mu.product_id
    -> where s.order_date < m.join_date
    -> group by s.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select s.customer_id, 
    -> sum(case 
    -> when m.product_name = 'sushi' then mu.price * 20
    -> else mu.price * 10
    -> end) as total_points
    -> from sales s 
    -> join menu as mu on s.product_id = mu.product_id
    -> group by s.cutomer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
select s.customer_id, 
    -> sum(case
    -> when s.order_date between m.join_date and date_add(m.join_date, interval 6 day)
    -> then mu.price * 20 
    -> else 
    -> case when mu.product_name = 'sushi' then mu.price * 20
    -> else mu.price * 10
    -> end
    -> end)
    -> as total_points
    -> from sales as s 
    -> join members as m on s.customer_id = m.customer_id
    -> join menu as mu on s.product_id = mu.product_id
    -> where s.customer_id in ('A', 'B')
    -> and s.order_date between '2021-01-01' and '2021-01-31'
    -> group by s.customer_id;

