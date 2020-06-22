USE ASUZD

BEGIN TRAN fixesImport20200204

DECLARE @PRids TABLE (Id bigint)
DECLARE @OldNumbers TABLE (Id bigint, PurchaseNumber nvarchar(max), LotNumber nvarchar(max))
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

INSERT INTO @OldNumbers
SELECT Id,
		PurchaseNumber,
		LotNumber
FROM dbo.PurchaseRequests
WHERE ID in (SELECT Id FROM @PRids)

-- suzd\Csp.Data\Models\PurchaseRequest.cs:801
-- // backlog #655
-- this.PurchaseNumber = this.Id.ToString();
-- this.LotNumber = this.Id.ToString();
UPDATE dbo.PurchaseRequests 
	SET PurchaseNumber = Id,
		LotNumber = Id
	WHERE ID in (SELECT Id FROM @PRids)


SELECT PR.Id,
		OPR.PurchaseNumber as OLD_PurchaseNumber,
		PR.PurchaseNumber as NEW_PurchaseNumber,
		OPR.LotNumber as OLD_LotNumber,
		PR.LotNumber as NEW_LotNumber
FROM dbo.PurchaseRequests PR
LEFT JOIN @OldNumbers OPR ON PR.Id = OPR.Id
WHERE PR.ID in (SELECT Id FROM @PRids)

rollback