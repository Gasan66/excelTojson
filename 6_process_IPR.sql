use ASUZD
BEGIN TRANSACTION
DECLARE @WhoMakesImport AS nvarchar(128) = (SELECT Id FROM dbo.AspNetUsers WHERE Email = 'adm@suzd.ru');
DECLARE @ImportedPRs AS TABLE (Id bigint)

;WITH 
ImportIds
	AS
	(
		--����� ������
		SELECT AiR.PurchaseRequestId [Id]
		FROM dbo.AuditItems Ai
			LEFT JOIN dbo.AuditItemRequests AiR ON AiR.ItemId = Ai.Id
		WHERE AI.[Message] LIKE N'������������� 2020.05.20 21:24:47%'
		--������������� �������
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
				WHEN IPrO.Code LIKE N'%����%' THEN N'��'
				WHEN IPrO.Code LIKE N'%�����%' THEN N'��'
				WHEN IPrO.Code LIKE N'%������%' THEN N'��'
			END [OKATOkey],
			IPrO.*
		FROM dbo.InvestPrograms IPr
			LEFT JOIN dbo.IprObjects IPrO ON IPrO.InvestProgramId = IPr.Id
		WHERE (IPr.Id = N'������������ �� 2018-2022 ���� ��� ��� ����� �����')
			AND IPrO.[Name] = N'��������������� ������������� ����������������� ��������� ������������ ������������ ��������� �� 15 ��� ������������'
		--������������� �������
	),
	ImportIds
	AS
	(
		--����� ������
		SELECT AiR.PurchaseRequestId [Id]
		FROM dbo.AuditItems Ai
			LEFT JOIN dbo.AuditItemRequests AiR ON AiR.ItemId = Ai.Id
		WHERE AI.[Message] LIKE N'������������� 2020.05.20 21:24:47%'
		--������������� �������
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
		--����� ������� ��������
		SELECT
			CASE
				WHEN OKATO.[name] LIKE N'%����%' THEN N'��'
				WHEN OKATO.[name] LIKE N'%�����%' THEN N'��'
				WHEN OKATO.[name] LIKE N'%������%' THEN N'��'
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