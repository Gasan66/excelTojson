use ASUZD
BEGIN TRANSACTION
DECLARE @WhoMakesImport AS nvarchar(128) = (SELECT Id FROM dbo.AspNetUsers WHERE Email = 'adm@suzd.ru');
DECLARE @ImportedPRs AS TABLE (Id bigint)

;WITH 
ImportIds
	AS
	(
		--найти импорт
		SELECT AiR.PurchaseRequestId [Id]
		FROM dbo.AuditItems Ai
			LEFT JOIN dbo.AuditItemRequests AiR ON AiR.ItemId = Ai.Id
		WHERE AI.[Message] LIKE N'»мпортировано 2020.05.20 21:24:47%'
		--редактировать вручную
	)
INSERT INTO @ImportedPRs
SELECT Id FROM ImportIds

-- AddIPRtoSAPimport
;
WITH
	myIprObjects
	AS
	(
		SELECT
			CASE 
				WHEN IPrO.Code LIKE N'%перм%' THEN N'ѕЁ'
				WHEN IPrO.Code LIKE N'%чел€б%' THEN N'„Ё'
				WHEN IPrO.Code LIKE N'%свердл%' THEN N'—Ё'
			END [OKATOkey],
			IPrO.*
		FROM dbo.InvestPrograms IPr
			LEFT JOIN dbo.IprObjects IPrO ON IPrO.InvestProgramId = IPr.Id
		WHERE (IPr.Id = N'”твержденна€ на 2018-2022 годы дл€ ќјќ Ђћ–—  ”ралаї')
			AND IPrO.[Name] = N'“ехнологическое присоединение энергопринимающих устройств потребителей максимальной мощностью до 15 к¬т включительно'
		--редактировать вручную
	),
	ImportIds
	AS
	(
		--найти импорт
		SELECT AiR.PurchaseRequestId [Id]
		FROM dbo.AuditItems Ai
			LEFT JOIN dbo.AuditItemRequests AiR ON AiR.ItemId = Ai.Id
		WHERE AI.[Message] LIKE N'»мпортировано 2020.05.20 21:24:47%'
		--редактировать вручную
	),
	PR
	AS
	(
		SELECT PR.*
		FROM dbo.PurchaseRequests PR INNER JOIN ImportIds i ON i.Id = PR.Id
		WHERE PR.IsInIpr = 1
	),
	PR_OKATOkey
	AS
	(
		--найти область поставки
		SELECT
			CASE
				WHEN OKATO.[name] LIKE N'%перм%' THEN N'ѕЁ'
				WHEN OKATO.[name] LIKE N'%чел€б%' THEN N'„Ё'
				WHEN OKATO.[name] LIKE N'%свердл%' THEN N'—Ё'
			END [OKATOkey],
			PR.*
		FROM PR
			LEFT JOIN dbo.NsiOkatoItems OKATO ON OKATO.code = PR.Okato
	)
INSERT INTO dbo.PurchaseRequestIprObjects
SELECT iPR.Code, iPR.InvestProgramId, PR.Id
FROM PR_OKATOkey PR
	LEFT JOIN myIprObjects iPR ON iPR.OKATOkey = PR.OKATOkey

--echo result
SELECT *
FROM dbo.PurchaseRequestIprObjects PRIO
WHERE RequestId in (select Id from @ImportedPRs)
ORDER BY RequestId


ROLLBACK