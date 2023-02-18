use sakila;

-- Write a query to find what is the total business done by each store.

select s.store_id, sum(p.amount) from store s
join staff st on s.store_id = st.store_id
join payment p on st.staff_id = p.staff_id
group by s.store_id;

-- Convert the previous procedure into a stored procedure

drop procedure if exists turnover_made_by_shops;

DELIMITER //
CREATE PROCEDURE turnover_made_by_shops ()
begin
select s.store_id, sum(p.amount) turnover from store s
join staff st on s.store_id = st.store_id
join payment p on st.staff_id = p.staff_id
group by s.store_id;
end //

DELIMITER ;

call turnover_made_by_shops();

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists turnover_made_by_this_shop;

DELIMITER //
CREATE PROCEDURE turnover_made_by_this_shop (IN x INT)
begin
select * from (
select s.store_id, sum(p.amount) turnover from store s
join staff st on s.store_id = st.store_id
join payment p on st.staff_id = p.staff_id
group by s.store_id
)sub1
where store_id = x;
end //
DELIMITER ;

call turnover_made_by_this_shop(2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

drop procedure if exists turnover_made_by_the_shop;

DELIMITER //
CREATE PROCEDURE turnover_made_by_the_shop (IN param1 INT, out param2 float)
begin
declare total_sales_value float default 0.00;
select turnover into total_sales_value from (
select s.store_id, sum(p.amount) turnover from store s
join staff st on s.store_id = st.store_id
join payment p on st.staff_id = p.staff_id
group by s.store_id
)sub1
where store_id = param1;

select total_sales_value into param2;

end //
DELIMITER ;

call turnover_made_by_the_shop(2, @total_sales_value);

select @total_sales_value;

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

drop procedure if exists turnover_made_by_the_shops_with_flag;

DELIMITER //
CREATE PROCEDURE turnover_made_by_the_shops_with_flag (in param1 INT, out param2 varchar(30))
begin
declare total_sales_value float default 0.00;
declare flag varchar(20) default "";
select turnover into total_sales_value from (
select s.store_id, sum(p.amount) turnover from store s
join staff st on s.store_id = st.store_id
join payment p on st.staff_id = p.staff_id
group by s.store_id
)sub1
where store_id = param1;

select total_sales_value;

  case
    when total_sales_value > 30000 then
      set flag = 'green_flag';
  else
    set flag = 'red_flag';
  end case;
  
  select flag into param2;
  
end //
DELIMITER ;

call turnover_made_by_the_shops_with_flag(1, @flag_color);
select @flag_color;



