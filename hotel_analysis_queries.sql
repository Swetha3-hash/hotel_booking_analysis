-- Hotel Booking Analysis SQL Queries
-- Author: Swetha Panidapu
-- Dataset: Hotel Booking Demand (Kaggle)

create database hotel_analysis;
use hotel_analysis;

SELECT COUNT(*) FROM hotel_bookings_clean;

-- Q1. Overall cancellation rate by hotel type
select hotel, 
		count(*) as total_bookings,
        sum(is_canceled) as cancellations,
        round(100.0* sum(is_canceled)/ count(*) ,1) as cancellation_rate
from hotel_bookings_clean
group by hotel;

-- Q2. Monthly revenue trend
SELECT 
    arrival_date_year,
    arrival_date_month,
    CASE arrival_date_month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END AS month_num,
    ROUND(SUM(total_revenue), 0) AS monthly_revenue,
    COUNT(*) AS bookings
FROM hotel_bookings_clean
WHERE is_canceled = 0
GROUP BY arrival_date_year, arrival_date_month
ORDER BY arrival_date_year, month_num;

-- Q3. Cancellation by market segment
select market_segment,
		count(*) as total_bookings,
		sum(is_canceled) as cancellations,
        round(sum(is_canceled)* 100/ count(*), 1) as cancel_rate
from hotel_bookings_clean
group by market_segment
order by cancel_rate desc;

-- Q4.Total revenue lost due to cancellations
select hotel,
		round(sum(total_revenue),0) as potential_revenue,
        round(sum(case when is_canceled= 0 then total_revenue else 0 end),0) as actual_revenue,
       round(sum(case when is_canceled= 1 then total_revenue else 0 end),0) as lost_revenue
from hotel_bookings_clean
group by hotel;

-- Q5.Lead time vs cancellations

select 
case
when lead_time <=7 then '1-last minute (0-7days)'
when lead_time <= 30 then '2- short (8-30 days)'
when lead_time <= 90 then '3- medium(31-90 days)'
else '4- long(90+ days)'
end as booking_window,
count(*) as total_bookings,
round(100* sum(is_canceled)/count(*),1) as cancel_rate
from hotel_bookings_clean
group by booking_window
order by booking_window;

-- Q6.Top 10 countries by confirmed bookings
select count(*) as total_bookings, country, ROUND(SUM(total_revenue), 0) AS total_revenue
from hotel_bookings_clean
where is_canceled=0
group by country
order by total_bookings desc
limit 10;

-- Q7. Cancellation rate by Customer type
SELECT customer_type,
       COUNT(*) AS total_bookings,
       ROUND(100.0 * SUM(is_canceled) / COUNT(*), 1) AS cancel_rate
FROM hotel_bookings_clean
GROUP BY customer_type
ORDER BY cancel_rate DESC;

        
        