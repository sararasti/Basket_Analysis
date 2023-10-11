SELECT 
   s.OrderId
   ,SUM(QtyFinal)
   ,sum(QtyFinal*PriceInclTax)  SaleAmount
   ,count(OrderId) CountOrder
   ,d.AttributeSetName
   ,d.AttributeSetId
   ,d.CategoryName_Level2
   ,ProductMiddleCategory
   ,ProductName
   ,d.ProductCode
   ,s.CouponCode
FROM Sale.FactSale s
 join Sale.DimCustomer dc
   ON s.CustomerCode=dc.CustomerCode
 join Marketing.DimCoupon c
   ON c.CouponCode=s.CouponCode
 join Inventory.DimProduct d
   ON d.ProductCode=s.ProductCode
 WHERE 
      s.DateKey>=14020201
  AND s.OrderStatusCode NOT IN ('canceled','closed','return_after_shipment','not_delivered','waiting_for_reception')
  AND s.CustomerCode NOT IN (9026577,9168017) AND CustomerGroupCode NOT IN (8,9,4)
  AND AttributeSetId IN (36,77,17,35,40,31,33,32,64,39,34,42,71,69,37)
  AND OrderId IN 
           (SELECT OrderId
		          
                 FROM Sale.FactSale n
				 group by OrderId
				    having count(n.OrderId)>1 --AND count(n.OrderId)<=10
					) 
 group by s.CustomerCode,ProductSubCategory
 ,ProductMiddleCategory
 ,ProductName
 ,s.CouponCode
 ,s.OrderId
 ,d.AttributeSetName
 ,d.CategoryName_Level2
 ,d.AttributeSetId
 ,d.ProductCode