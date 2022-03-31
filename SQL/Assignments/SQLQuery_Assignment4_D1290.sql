with tbl as (
		select product_id, discount, sum(quantity) as sale_quantity
		from sale.order_item
		group by product_id, discount
			 )
select product_id, 
	CASE 
        WHEN AVG(A.sale_quantity) < AVG(A.lead1) THEN 'Positive'
		WHEN AVG(A.sale_quantity) > AVG(A.lead1) THEN 'Negative'
		WHEN AVG(A.sale_quantity) = AVG(A.lead1) THEN 'Neutral'
        ELSE '-'
    END as [Discount Effect]
from	(
		select	distinct product_id, discount, sale_quantity,
		lead(sale_quantity, 1) over(partition by product_id order by product_id) lead1
		from	tbl
		) A
group by A.product_id
