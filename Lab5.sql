insert into salesman 
values
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'),
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');

insert into salesorder
values
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');

insert into salesorderdetails
values 
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);

-- 1. Display the clients (name) who lives in same city
select distinct c1.client_name, c2.Client_Name, c1.City
from clients c1 inner join clients c2 
on c1.City = c2.City and c1.Client_Number <> c2.Client_Number;

-- 2.Display city, the client names and salesman names who are lives in “Thu Dau Mot” city
select c.City, c.Client_Name, s.Salesman_Name
from Clients c
inner join Salesman s
on c.City = 'Thu Dau Mot' 
where c.City = s.City;

-- 3. Display client name, client number, order number, salesman number, and product number for each 
-- order.
select c.client_name, c.client_number,
sd.order_number, sd.salesman_number,
sod.product_number 
from clients c 
inner join salesorder sd
on c.Client_Number = sd.Client_Number
inner join salesorderdetails sod
on sod.Order_Number = sd.Order_Number;

-- 4. Find each order (client_number, client_name, order_number) placed by each client.
select c.client_number, c.client_name, s.order_number
from clients c inner join salesorder s
on c.Client_Number = s.Client_Number;

-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by 
-- them.
select c.client_number, c.client_name, count(s.Order_Number) numOrder
from clients c inner join salesorder s
on  c.Client_Number = s.Client_Number 
group by c.Client_Number;

-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
select c.client_number, c.client_name
from clients c inner join salesorder s
on  c.Client_Number = s.Client_Number 
group by c.Client_Number having count(Order_Number) > 2;


-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select c.client_number, c.client_name
from clients c inner join salesorder s 
on c.Client_Number = s.Client_Number
group by c.Client_Number having count(Order_Number) > 1 
order by c.Client_Number desc;

-- 8. Find the salesman names who sells more than 20 products.
select sm.salesman_name
from salesman sm 
inner join salesorder s
on sm.Salesman_Number = s.Salesman_Number
inner join salesorderdetails sod
on sod.Order_Number = s.Order_Number
group by sm.Salesman_Name having sum(sod.order_quantity) > 20;

-- 9. Display the client information (client_number, client_name) and order number of those clients who 
-- have order status is cancelled.
select c.client_number, c.client_name
from clients c inner join salesorder s
on c.Client_Number = s.Client_Number
where s.Order_Status = 'Cancelled';

-- 10. Display client name, client number of clients C101 and count the number of orders which were 
-- received “successful
select c.client_name, c.client_number, count(s.order_status) as numberOrder
from clients c 
inner join salesorder s
on c.Client_Number = s.Client_Number
where s.Order_Status = 'Successful' 
and c.Client_Number = 'C101';

-- 11. Count the number of clients orders placed for each product.
select sod.Product_Number, count(c.client_number) as numOrder
from clients c 
inner join salesorder s
on c.Client_Number = s.Client_Number
inner join salesorderdetails sod
on sod.Order_Number = s.Order_Number
group by sod.Product_Number;

-- 12. Find product numbers that were ordered by more than two clients then order in descending by product 
-- number
select sod.Product_Number, count(c.client_number) as numOrder
from clients c 
inner join salesorder s
on c.Client_Number = s.Client_Number
inner join salesorderdetails sod
on sod.Order_Number = s.Order_Number
group by sod.Product_Number having numOrder > 2
order by sod.Product_Number desc;

-- 13. Find the salesman’s names who is getting the second highest salary
select sm.salesman_name
from salesman sm 
where salary = (select distinct Salary from salesman 
order by salary desc limit 1 offset 1);

-- 14. Find the salesman’s names who is getting second lowest salary.
select sm.salesman_name
from salesman sm 
where salary = (select distinct Salary from salesman 
order by salary asc limit 1 offset 1);

select * from salesman order by salary asc;

-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the 
-- salesman whose salesman number is S001
select salesman_name 
from salesman where salary > 
(select salary from salesman where Salesman_Number = 'S001');

-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select sm.salesman_name
from salesman sm 
where Salesman_Number in (select s.Salesman_Number
from salesorder s 
inner join salesorderdetails sod
on s.Order_Number = sod.Order_Number 
where sod.Product_Number = 'P1002');


-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered"
select sm.salesman_name
from salesman sm
where Salesman_Name in (select s.Salesman_Number 
from salesorder s
inner join salesorderdetails sod 
on s.Order_Number = sod.Order_Number
where s.Client_Number = 'C108' and s.Delivery_Status = 'Delivered');

-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal 
-- to 5.
select p.product_name 
from product p 
where Product_Number in (select Product_Number 
from salesorderdetails where Order_Quantity = 5);

-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select sm.salesman_name, sm.salesman_number
from salesman sm 
where Salesman_Number in (
	select s.salesman_number 
    from salesorder s
    inner join salesorderdetails sod
    on s.Order_Number = sod.Order_Number
    inner join product p
    on p.Product_Number = sod.Product_Number
    where p.Product_Name in ('Pen', 'TV', 'Laptop')
);

-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand
-- more than 50.
select sm.salesman_name 
from salesman sm where Salesman_Number in (
	select s.salesman_number 
    from salesorder s
    inner join salesorderdetails sod
    on s.Order_Number = sod.Order_Number
    inner join product p
    on p.Product_Number = sod.Product_Number
    where p.Sell_Price < 800 and p.Quantity_On_Hand > 50
);

-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average 
-- salary
select Salesman_Name, Salary
from Salesman
where Salary > (
  select avg(Salary) 
  from Salesman
);

-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the 
-- average amount paid
select client_name, amount_paid
from clients
where Amount_Paid > (
  select avg(Amount_Paid) 
  from clients
);

-- 23. Find the product price that was sold to Le Xuan.
select sell_price 
from product where Product_Number in (
	select sod.Product_Number
    from salesorderdetails sod 
    inner join salesorder s
    on sod.Order_Number = s.Order_Number
    inner join clients c
    on c.Client_Number = s.Client_Number
    where c.Client_Name = 'Le Xuan'
);

-- 24. Determine the product name, client name and amount due that was delivered.
select p.product_name, c.client_name, c.amount_due
from salesorder s 
inner join salesorderdetails sod
on s.Order_Number = sod.Order_Number
inner join product p 
on p.Product_Number = sod.Product_Number
inner join clients c
on c.Client_Number = s.Client_Number
where s.Delivery_Status = 'Delivered';

-- 25. Find the salesman’s name and their product name which is cancelled.
select sm.salesman_name, p.product_name
from salesman sm 
inner join salesorder s 
on sm.Salesman_Number = s.Salesman_Number
inner join salesorderdetails sod
on s.Order_Number = sod.Order_Number
inner join product p 
on p.Product_Number = sod.Product_Number
where s.Order_Status = 'Cancelled';

-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
select p.product_name, p.Sell_Price, s.Delivery_Status
from salesorder s
inner join salesorderdetails sod
on s.Order_Number = sod.Order_Number
inner join product p 
on p.Product_Number = sod.Product_Number
inner join clients c
on c.Client_Number = s.Client_Number
where c.Client_Name = 'Nguyen Thanh';

-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information 
-- for each customer
select p.product_name, p.Sell_Price, sm.salesman_name, s.Delivery_Status, sod.Order_Quantity
from salesorder s
inner join salesorderdetails sod on s.Order_Number = sod.Order_Number
inner join product p on p.Product_Number = sod.Product_Number
inner join salesman sm on sm.Salesman_Number = s.Salesman_Number;

-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been 
-- successful but the items have not yet been delivered to the client.
select sm.Salesman_Name, p.Product_Name, s.Order_Date
from salesman sm
inner join salesorder s on s.Salesman_Number = sm.Salesman_Number
inner join salesorderdetails sod on sod.Order_Number = s.Order_Number
inner join product p on p.Product_Number = sod.Product_Number
where s.Order_Status = 'Successful' and s.Delivery_Status <> 'Delivered';

-- 29. Find each clients’ product which in on the way.
select c.client_name, p.Product_Name
from salesorder s
inner join salesorderdetails sod on sod.Order_Number = s.Order_Number
inner join product p on p.Product_Number = sod.Product_Number
inner join clients c on c.Client_Number = s.Client_Number
where s.Delivery_Status = 'On way';

-- 30. Find salary and the salesman’s names who is getting the highest salary.
select salary, salesman_name 
from salesman where salary = (select salary 
from salesman order by salary desc limit 1);

-- 31. Find salary and the salesman’s names who is getting second lowest salary.
select salary, salesman_name 
from salesman where salary = (select  distinct salary 
from salesman order by salary asc limit 1 offset 1);


-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more 
-- than 9.
select p.product_name 
from product p 
where Product_Number in (select Product_Number 
from salesorderdetails where Order_Quantity > 9);

-- 33. Find the name of the customer who ordered the same item multiple times.
select c.client_name, p.Product_Number
from clients c 
inner join salesorder s on s.Client_Number = c.Client_Number
inner join salesorderdetails sod on s.Order_Number = sod.Order_Number
inner join product p on p.Product_Number = sod.Product_Number
group by c.client_name, p.Product_Number having count(p.Product_Number) >= 2;

-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average 
-- salary and works in any of Thu Dau Mot city.
select sm.salesman_name, sm.salesman_number, sm.salary 
from salesman sm where sm.salary < (select avg(salary) 
from salesman) and sm.City = 'Thu Dau Mot';

-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than 
-- the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to 
-- highest
select sm.salesman_name, sm.salesman_number, sm.salary
from salesman sm
where salary > (
select max(salary) from salesman sa
inner join salesorder s on s.Salesman_Number = sa.Salesman_Number
where s.Order_Status = 'Cancelled'
)
order by Salary asc;

-- 36. Write a query to find the 4th maximum salary on the salesman’s table
select salary from salesman
where salary = (select distinct salary 
from salesman order by salary desc limit 1 offset 3);

-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
select salary from salesman
where salary = (select distinct salary 
from salesman order by salary asc limit 1 offset 2);
