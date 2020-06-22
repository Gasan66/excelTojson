use ASUZD
--<3_выставление согласований>
BEGIN TRANSACTION
DECLARE @WhoMakesImport AS nvarchar(128) = (SELECT Id FROM dbo.AspNetUsers WHERE Email = 'adm@suzd.ru');
DECLARE @AuditMessage1 AS nvarchar(max) = (N'Заявка отправлена на согласование')
DECLARE @AuditMessage2 AS nvarchar(max)
DECLARE @ImportedPRs AS TABLE (Id bigint)
DECLARE @AtTime datetime2(7) = GETDATE()
;
WITH Import AS (
	SELECT AiR.PurchaseRequestId FROM dbo.AuditItems Ai
	LEFT JOIN dbo.AuditItemRequests AiR ON AiR.ItemId = Ai.Id
	WHERE AI.[Message] LIKE N'Импортировано 2020.05.20 21:24:47%' -- !!!! редактировать вручную !!!!
)
INSERT INTO @ImportedPRs
SELECT PurchaseRequestId FROM Import

DECLARE @TemplateApproval AS TABLE (Id bigint, [Type] nvarchar(255), [Description] nvarchar(255))

-- GET Template Approval
;WITH TemplateApproval as (
	SELECT *
	FROM dbo.TemplateApprovals
	where [Type] = 'NoSOKS_BDR'
)
INSERT INTO @TemplateApproval
SELECT Id, [Type], [Description] FROM TemplateApproval

DECLARE @TemplateApprovalId bigint = (select top 1 Id from @TemplateApproval);

-- GET Template Approval routes
DECLARE @TemplateRoutes as Table(
	[Order] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
    [TimeOfDecided] [datetime] NULL,
	[Decision] [int] NULL,
	[Message] [nvarchar](max) NULL,
	[ApproverRoleId] [nvarchar](max) NULL,
	[ApproverUserId] [nvarchar](max) NULL,
	[IsPersonal] [bit] NOT NULL,
	[IsGroup] [bit] NOT NULL,
	[IsHeadOfInitiator] [bit] NOT NULL
)
;WITH TemplApprovalRoutes as (
	SELECT [Order], ApproverRoleId, ApproverUserId, IsPersonal, IsGroup, IsHeadOfInitiator 
	FROM dbo.TemplateApprovalRoutes 
	where RequestApproval_Id = @TemplateApprovalId
)
INSERT INTO @TemplateRoutes
SELECT t.[Order], 1, NULL, NULL, NULL, t.ApproverRoleId, t.ApproverUserId, t.IsPersonal, t.IsGroup, t.IsHeadOfInitiator FROM TemplApprovalRoutes t


-- update first route
-- Kuzminykh-VV@rosseti-ural.ru - ORDER 1
UPDATE @TemplateRoutes SET ApproverRoleId = '05ccb15e-6592-4301-b417-c8facbe987e9',	ApproverUserId = '5d7dac6b-ed28-4a7f-984f-89392752bf12', Decision = 1, TimeOfDecided = @AtTime, IsActive = 0 WHERE [Order] = 1
-- update bezop route and other
-- set Knyazeva-OA@rosseti-ural.ru - -- ORDER 6
UPDATE @TemplateRoutes SET [Order] = 6, ApproverUserId = 'a8756969-880f-41ba-80ec-00178e044b75', IsPersonal = 1, IsGroup = 0 , IsActive = 0 WHERE [Order] = 5
-- ORDER 5 - Павлюкевич
UPDATE @TemplateRoutes SET [Order] = 5, IsActive = 1 WHERE [Order] = 4
-- ORDER 4 - Департамент безопасности
UPDATE @TemplateRoutes SET [Order] = 4, Decision = 1, TimeOfDecided = @AtTime, IsActive = 0 WHERE [Order] = 2

-- add custom routes
-- ORDER 2 - Департамент капитального строительства
INSERT INTO @TemplateRoutes values(2, 0,  @AtTime, 1, NULL, '313cbb7d-28cf-4f7d-bc46-5163425e6872', NULL, 0,1,0)
-- ORDER 3 - Департамент экономики и тарифообразования
INSERT INTO @TemplateRoutes values(3, 0,  @AtTime, 1, NULL, 'a1b3e18b-81de-474f-b6c1-67bf4b284840', NULL, 0,1,0)
--SELECT * FROM @TemplateRoutes order by [Order]

-- CREATE Approval
WHILE (SELECT COUNT(*) FROM @ImportedPRs) > 0
BEGIN 
	DECLARE @AddedTime datetime2(7) = GETDATE();
	DECLARE @RequestId bigint = (SELECT TOP(1) Id FROM @ImportedPRs);
	-- declare prop of Approval
	DECLARE @Type [nvarchar](max) = (SELECT top 1 Type from @TemplateApproval);
	DECLARE @Description [nvarchar](max) = (SELECT top 1 Description from @TemplateApproval);
	DECLARE @CreationTime [datetime2](7) = @AddedTime;
	DECLARE @IsCompleted [bit] = 0;
	DECLARE @IsActive [bit] = 1;
	DECLARE @Initiator [nvarchar](max) = @WhoMakesImport;
	
	-- insert approval
	INSERT INTO [dbo].[RequestApprovals]
	        (
				[Type] ,[Description] ,[CreationTime] ,[IsCompleted] ,[IsActive] ,[Initiator]
			   ,[PlannedSumByNotificationNotax] ,[SumTzNoTax] ,[Deadline] ,[IsInIpr] ,[IsInBdr] ,[PurchaseRequest_Id]
			   ,[NameOfRequest] ,[ApprovalType] ,[CompletedTime] ,[ApprovalResult] ,[CycleId] ,[Stage] ,[Status] 
		   )
		   SELECT top 1
			   @Type, @Description, @CreationTime, @IsCompleted, @IsActive, @Initiator,
			   r.PlannedSumByNotificationNotax, 0, 0, r.IsInIpr, r.IsInBdr, r.Id,
			   r.Name, NULL, NULL, NULL, ac.Id, r.Stage, r.Status
		   FROM dbo.PurchaseRequests r 
		   LEFT JOIN dbo.AuctionCycles ac on ac.RequestId = r.Id
		   where r.Id = @RequestId


	DECLARE @ApprovalId bigint = SCOPE_IDENTITY();

	-- insert routes
	INSERT INTO dbo.RequestApprovalRoutes(
		[Order]
      ,[IsActive]
      ,[TimeOfDecided]
      ,[Decision]
      ,[Message]
      ,[RequestApproval_Id]
      ,[ApproverRoleId]
      ,[ApproverUserId]
      ,[IsPersonal]
      ,[IsGroup]
      ,[IsHeadOfInitiator]
	)
	SELECT 
		[Order], 
		IsActive,
		TimeOfDecided,
		Decision, 
		Message, 
		@ApprovalId as 'RequestApproval_Id',
		ApproverRoleId,
		ApproverUserId,
		IsPersonal,
		IsGroup,
		IsHeadOfInitiator
	FROM @TemplateRoutes
	order by [Order]

	-- send request to Approval status
	update dbo.PurchaseRequests 
		set Version = 1,
			Status = 20 -- ApprovalCzo
			WHERE Id = @RequestId

	--audit
	EXECUTE sp_AddAuditItemRequest @AddedTime,@WhoMakesImport,@RequestId,@AuditMessage1

	-- SET @AuditMessage2 = N'Согласование № ' + CAST(@ApprovalId AS nvarchar(50)) + N' завершено'
	-- EXECUTE sp_AddAuditItemRequest @AddedTime, @WhoMakesImport, @RequestId, @AuditMessage2
	--decrement
	BEGIN
		DELETE top (1) FROM @ImportedPRs 
		
	END
END

SELECT r.Id rid,
u.UserName,
g.name,
a.*,ar.*
FROM dbo.PurchaseRequests r 
LEFT JOIN dbo.RequestApprovals a on r.Id = a.PurchaseRequest_Id
LEFT JOIN dbo.RequestApprovalRoutes ar on ar.RequestApproval_Id = a.id
LEFT JOIN dbo.AspNetUsers u on ar.ApproverUserId = u.id
LEFT JOIN dbo.AspNetRoles g on ar.ApproverRoleId = g.id
where r.Id = 24161

rollback
--</3_выставление согласований>

