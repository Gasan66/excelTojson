USE ASUZD

BEGIN TRAN fixesImport0520

DECLARE @PRids TABLE (Id bigint)
DECLARE @OldNumbers TABLE (PRId bigint, ACId bigint, CzoItemId bigint, ProtocolId bigint, NumberPurchase nvarchar(max), NumberLot nvarchar(max))
;
WITH
    Import
    AS
    (
        SELECT AiR.PurchaseRequestId
        FROM dbo.AuditItems Ai
            LEFT JOIN dbo.AuditItemRequests AiR ON AiR.ItemId = Ai.Id
        WHERE AI.[Message] LIKE N'Импортировано 2020.05.20 21:24:47%' --редактировать вручную
    )
INSERT INTO @PRids
SELECT PurchaseRequestId
FROM Import

-- save old vals
INSERT INTO @OldNumbers
SELECT PR.Id as PRID, AC.Id as ACID, PC.Id as CzoItemId, PC.Protocol_Id, PC.NumberPurchase ,PC.NumberLot
FROM @PRids PR 
left JOIN dbo.AuctionCycles AC on PR.Id = AC.RequestId 
LEFT JOIN dbo.ProtocolCzoItems PC on AC.Id = PC.AuctionCycleId
WHERE PC.Protocol_Id is not null

-- update
UPDATE PC
	SET NumberPurchase = AC.RequestId,
		NumberLot = AC.RequestId
	FROM dbo.ProtocolCzoItems PC 
		left join dbo.AuctionCycles AC on PC.AuctionCycleId = AC.Id
WHERE PC.Id in (SELECT CzoItemId FROM @OldNumbers)

-- view updated
SELECT PR.Id as PRID, AC.Id as ACID, PC.Id as CzoItemId, PC.Protocol_Id, OLD.NumberPurchase, PC.NumberPurchase, OLD.NumberLot ,PC.NumberLot
FROM @PRids PR 
left JOIN dbo.AuctionCycles AC on PR.Id = AC.RequestId 
LEFT JOIN dbo.ProtocolCzoItems PC on AC.Id = PC.AuctionCycleId
LEFT JOIN @OldNumbers OLD on OLD.CzoItemId = PC.Id
WHERE PC.Protocol_Id is not null

ROLLBACK TRAN