DECLARE @LastId bigint = (select top 1 Id from PurchaseRequests order by id desc)

DBCC CHECKIDENT ('PurchaseRequests');

DBCC CHECKIDENT ('PurchaseRequests', RESEED, @LastId);
GO