Authors
+----------+--------------------+----------------+-----------+
| authorid | name               | country        | birthyear |
+----------+--------------------+----------------+-----------+
|        1 | J.K. Rowling       | United Kingdom |      1965 |
|        2 | George R.R. Martin | United States  |      1948 |
|        3 | Haruki Murakami    | Japan          |      1949 |
+----------+--------------------+----------------+-----------+

books
+--------+---------------------------------------+----------+---------+-------+-------+
| bookid | title                                 | authorid | genre   | price | stock |
+--------+---------------------------------------+----------+---------+-------+-------+
|      1 | Harry Potter and the Sorcerer"s Stone |        1 | Fantasy | 19.99 |   120 |
|      2 | A Game of Thrones                     |        2 | Fantasy | 24.99 |    80 |
|      3 | Norwegian Wood                        |        3 | Fiction | 14.99 |    50 |
+--------+---------------------------------------+----------+---------+-------+-------+

customers
+------------+---------------+---------------------+------------+----------------+
| customerid | name          | email               | joindate   | country        |
+------------+---------------+---------------------+------------+----------------+
|          1 | Alice Johnson | alice@example.com   | 2023-01-15 | UNnited States |
|          2 | Bob Smith     | bob@example.com     | 2023-02-20 | Canada         |
|          3 | Charlie Brown | charlie@example.com | 2023-03-05 | United Kingdom |
+------------+---------------+---------------------+------------+----------------+

orders
+---------+------------+--------+------------+----------+------------+
| orderid | customerid | bookid | orderdate  | quantity | totalprice |
+---------+------------+--------+------------+----------+------------+
|       1 |          1 |      1 | 2023-03-10 |        2 |      39.98 |
|       2 |          2 |      2 | 2023-03-15 |        1 |      24.99 |
|       3 |          3 |      3 | 2023-03-20 |        3 |      44.97 |
+---------+------------+--------+------------+----------+------------+

Basic Queries
1. Write a query to display all the authors in the database.
select authorid, name from authors;

2. Retrieve the names and emails of all customers who joined after February 1, 2023.
select name, email from customers 
where joindate > '2023-02-01';

3. Find all books in the 'Fantasy' genre.
select title, genre from books
where genre = 'Fantasy';

4. Display the total number of books available in stock.
select SUM(stock) as available_stock from books;

Intermediate Queries
5. Show the total revenue generated from all orders.
select SUM(totalprice) as total_revenue from orders;

6. List the details of orders placed by the customer named 'Alice Johnson.'
select o.orderid, o.customerid, c.name as customername, o.bookid, o.orderdate, o.quantity  from orders as o 
join customers as c on o.customerid = c.customerid 
where c.name = 'Alice Johnson';

7. Identify the book with the highest price.
select title as bookname, price from books order by price DESC, bookname limit 1;

8. Retrieve the details of books that have less than 50 units in stock.
select * from books where stock < 50;

Joins
9. Write a query to list all books along with their author's name.
select b.title as books, a.name as authorname
    -> from books as b
    -> join authors as a on b.authorid = a.authorid
    -> order by b.title, a.name;

10. Display all orders with the customer name and book title included.
select o.orderid, o.customerid, c.name as customername, o.bookid, b.title as bookname, o.orderdate, o.quantity, o.totalprice
    -> from orders as o
    -> join customers as c on o.customerid = c.customerid
    -> join books as b on o.bookid = b.bookid;

Aggregations
11. Calculate the total number of orders placed by each customer.
select customerid, SUM(quantity) as total_orders from orders group by customerid;

12. Find the average price of books in the 'Fiction' genre.
select genre, AVG(price) as avg_price from books
    -> where genre = 'Fiction'
    -> group by genre;

13. Determine the author whose books have the highest combined stock.
select a.name as authorname, SUM(b.stock) as total_stock
    -> from authors as a
    -> left join books as b on a.authorid = b.authorid
    -> group by a.authorid
    -> order by total_stock DESC
    -> limit 1;

Filtering
14. Retrieve the names of authors born before 1950.
select name as authorname, birthyear from authors 
where birthyear < 1950 
order by birthyear;

15. Find all customers from the 'United Kingdom.'
select customerid, name as customername, country
    -> from customers
    -> where country = 'United Kingdom'
    -> order by customerid;

Advanced Queries
16. Write a query to list all books that have been ordered more than once.
select o.bookid, b.title as bookname, SUM(o.quantity) as nooftimes_ordered 
    -> from orders as o
    -> join books as b on o.bookid = b.bookid
    -> group by o.bookid
    -> having nooftimes_ordered > 1
    -> order by o.bookid;

17. Identify the top-selling book based on the quantity sold.
select o.bookid, b.title as bookname, SUM(o.quantity) as quantitysold
    -> from orders as o
    -> join books as b on o.bookid = b.bookid
    -> group by o.bookid
    -> order by quantitysold DESC
    -> limit 1;

18. Calculate the total stock value for each book (price * stock).
select bookid, title, SUM(price * stock) as stockvalue
    -> from books
    -> group by bookid
    -> order by stockvalue DESC;

Subqueries
19. Write a query to find the name of the customer who placed the most expensive order.
select o.customerid, c.name as customername, totalprice as expense 
    -> from orders as o 
    -> left join customers as c on o.customerid = c.customerid
    -> order by totalprice DESC
    -> limit 1;

20. Retrieve all books that have not been ordered yet.
select bookid, title from books
    -> where bookid not in (select bookid from orders);


