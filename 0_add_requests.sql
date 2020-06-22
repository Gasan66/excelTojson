USE ASUZD
GO
--<0_импорт>
BEGIN TRANSACTION ImportFromSAP_20200520
--DECLARATION PART
--audit
DECLARE @AuditMessage AS nvarchar(max)
DECLARE @WhoMakesImport AS nvarchar(128)

--ImportIdentity
DECLARE @ImportIdentity TABLE (Key1 nvarchar(max),
	Key2 nvarchar(max))

--ImportTable
DECLARE @ImportTable AS TABLE (
	SapId nvarchar(255),
	[Name] nvarchar(255),
	CustomerOrganization nvarchar(255),
	CustomerSubdivision nvarchar(255),
	CustomerFunctionalBlock nvarchar(255),
	PlannedPurchaseMethodCode nvarchar(255),
	CustomerOrganizer nvarchar(255),
	IsElectronicPurchase nvarchar(255),
	ForSmallOrMiddle nvarchar(255),
	IsInIpr nvarchar(255),
	IsInnovation nvarchar(255),
	IsONM nvarchar(255),
	IsInBdr nvarchar(255),
	ProductGroupId nvarchar(255),
	ProductTypeId nvarchar(255),
	OkvedId nvarchar(255),
	OkdpId nvarchar(255),
	CodeActivityId nvarchar(255),
	PurchaseRequestFinanceSources nvarchar(255),
	PurchasePriceDocumentCode nvarchar(255),
	PlannedSumNotax float,
	PlannedSumTax float,
	PlannedSumWith30PercReductionNotax nvarchar(255),
	PlannedSumWith30PercReductionTax nvarchar(255),
	PlannedSumByNotificationNotax float,
	PlannedSumByNotificationTax float,
	PublicationPlannedDate datetime,
	PurchaseCategory_Id nvarchar(255),
	SummingupTime datetime,
	PlannedPurchaseYear nvarchar(255),
	AdditionalInfo nvarchar(max),
	Note nvarchar(255),
	MinRequirementsForPurchaseGoods nvarchar(255),
	Qty float,
	Okeiguid int,
	Okato nvarchar(255),
	PlannedDateOfContract nvarchar(255),
	PlannedDateOfDelivery datetime,
	PlannedDateOfCompletion datetime,
	ReasonPurchaseEP nvarchar(255),
	ContractorName nvarchar(255),
	ContractorInn nvarchar(255),
	ContractorKpp nvarchar(255),
	IprYear nvarchar(255),
	InvestProjectCode nvarchar(255),
	InvestProjectName nvarchar(255),
	ConstructionDocumentsState nvarchar(255),
	DateEndProject nvarchar(255),
	CostProject float,
	MegaWatt nvarchar(255),
	Mba nvarchar(255),
	Kilometer nvarchar(255),
	ProcessConnection nvarchar(255),
	PrivilegedProcessConnection nvarchar(255)
						 )
--PurchaseRequests
BEGIN
	DECLARE @Name nvarchar(max)
	DECLARE @CustomerOrganization nvarchar(max)
	DECLARE @CustomerSubdivision nvarchar(max)
	DECLARE @CustomerFunctionalBlock nvarchar(max)
	DECLARE @PlannedPurchaseMethodCode nvarchar(128)
	DECLARE @CustomerOrganizer nvarchar(max)
	DECLARE @IsInnovation bit
	DECLARE @IsONM bit
	DECLARE @OkvedId nvarchar(128)
	DECLARE @OkdpId nvarchar(128)
	DECLARE @CodeActivityId nvarchar(128)
	DECLARE @PurchasePriceDocumentCode nvarchar(128)
	DECLARE @PurchaseCategory_Id int
	DECLARE @PlannedPurchaseYear nvarchar(max)
	DECLARE @AdditionalInfo nvarchar(max)
	DECLARE @Note nvarchar(max)
	DECLARE @MinRequirementsForPurchaseGoods nvarchar(max)
	DECLARE @Okato nvarchar(max)
	DECLARE @ReasonPurchaseEP nvarchar(max)
	DECLARE @ContractorName nvarchar(max)
	DECLARE @ContractorInn nvarchar(max)
	DECLARE @ContractorKpp nvarchar(max)
	DECLARE @IprYear nvarchar(max)
	DECLARE @InvestProjectCode nvarchar(max)
	DECLARE @InvestProjectName nvarchar(max)
	DECLARE @AddedTime datetime2(7)
	DECLARE @PurchasePlanId nvarchar(128)
	DECLARE @PurchasePlanYear nvarchar(max)
	DECLARE @Status int
	DECLARE @Stage int
	DECLARE @IsElectronicPurchase bit
	DECLARE @IsInIpr bit
	DECLARE @IsInBdr bit
	DECLARE @ProductGroupId int
	DECLARE @ProductTypeId int
	DECLARE @PlannedSumNotax decimal(18,2)
	DECLARE @PlannedSumTax decimal(18,2)
	DECLARE @PlannedSumWith30PercReductionNotax decimal(18,2)
	DECLARE @PlannedSumWith30PercReductionTax decimal(18,2)
	DECLARE @PlannedSumByNotificationNotax decimal(18,2)
	DECLARE @PlannedSumByNotificationTax decimal(18,2)
	DECLARE @PublicationPlannedDate datetime2(7)
	DECLARE @SummingupTime datetime2(7)
	DECLARE @AdditionalPRAttributeId bigint
	DECLARE @Okeiguid nvarchar(128)
	DECLARE @Qty decimal(18,2)
	DECLARE @IsFixedProcurement bit
	DECLARE @DateApprovalConstructionDocuments nvarchar(max)
	DECLARE @IsApprovedConstructionDocuments bit
	DECLARE @IsNeedConstructionDocuments bit
	DECLARE @DateEndProject datetime2(7)
	DECLARE @CostProject decimal(18,2)
	DECLARE @MegaWatt decimal(18,4)
	DECLARE @Mba decimal(18,4)
	DECLARE @Kilometer decimal(18,4)
	DECLARE @ProcessConnection bit
	DECLARE @PrivilegedProcessConnection bit
	DECLARE @ExpWerePpriceNegotiations bit
	DECLARE @ExpWinnerSumOnPpriceNegotiationsNoTax decimal(18,2)
	DECLARE @ExpWinnerSumOnPpriceNegotiationsTax decimal(18,2)
	DECLARE @ExpCountContractorsMspAtWinner int
	DECLARE @ExpTotalSumContractorsMspAtWinner decimal(18,2)
	DECLARE @ExpSummingupTime datetime2(7)
	DECLARE @ExpNumberOfFinalProtocol nvarchar(max)
	DECLARE @ExpDateSendFinalProtocolToProfileDepartmentChief datetime2(7)
	DECLARE @ExpDateConclusionContract datetime2(7)
	DECLARE @ExpEndDateOfContract datetime2(7)
	DECLARE @ExpDateRequestForAdditionalAgreement datetime2(7)
	DECLARE @ExpDateReceiptResolutionProtocolCzoAddAgreement datetime2(7)
	DECLARE @ExpDateConclusionAdditionalAgreement datetime2(7)
	DECLARE @CreatorUserId nvarchar(max)
	DECLARE @OwnerId nvarchar(128)
	DECLARE @OwnerOrganizationId nvarchar(128)
	DECLARE @Version int
	DECLARE @IsImported bit
	DECLARE @SapId nvarchar(max)
	DECLARE @ForSmallOrMiddle int
	DECLARE @ExpEnvelopeOpeningTime datetime2(7)
	DECLARE @ExpDateKonProc datetime2(7)
	DECLARE @PlannedDateOfCompletion datetime2(7)
	DECLARE @PlannedDateOfDelivery datetime2(7)
	DECLARE @PlannedDateOfContract datetime2(7)
END
--AuctionCycles
BEGIN
	DECLARE @AuctionCycleId bigint
	DECLARE @RequestId bigint
	DECLARE @IsActive bit
	DECLARE @CompletedTime datetime2(7)
	DECLARE @DateKonProc datetime2(7)
	DECLARE @EnvelopeOpeningTime datetime2(7)
	DECLARE @WerePpriceNegotiations bit
	DECLARE @WinnerSumOnPpriceNegotiationsNoTax decimal(18,2)
	DECLARE @WinnerSumOnPpriceNegotiationsTax decimal(18,2)
	DECLARE @CountContractorsMspAtWinner int
	DECLARE @TotalSumContractorsMspAtWinner decimal(18,2)
	DECLARE @SummingupTime_AC datetime2(7)
	DECLARE @FinalSumNoTax decimal(18,2)
	DECLARE @FinalSumTax decimal(18,2)
	DECLARE @DateSendFinalProtocolToProfileDepartmentChief datetime2(7)
	DECLARE @DateConclusionContract datetime2(7)
	DECLARE @EndDateOfContract datetime2(7)
	DECLARE @DateRequestForAdditionalAgreement datetime2(7)
	DECLARE @DateReceiptResolutionProtocolCzoAddAgreement datetime2(7)
	DECLARE @DateConclusionAdditionalAgreement datetime2(7)
	DECLARE @AddedTime_AC datetime2(7)
	DECLARE @ModifiedTime datetime2(7)
	DECLARE @Status_AC int
	DECLARE @Stage_AC int
	DECLARE @IsLongTermPurchase bit
END
--PurchaseRequestFinanceSources
DECLARE @PurchaseRequestFinanceSources AS TABLE (
	String nvarchar(max)
	)

--for inserting into LongTermPurschasePayments
DECLARE @PaymentYearIterator int

--DATA ASSIGNMENT PART
--audit
DECLARE @CURDATE VARCHAR(10) = CONVERT(VARCHAR(10),GETDATE(),102)
DECLARE @CURTIME VARCHAR(10) = CONVERT(VARCHAR(10),GETDATE(),108)
SET @AuditMessage = (N'Импортировано '  + @CURDATE + ' ' + @CURTIME)
SET @WhoMakesImport = (SELECT Id
FROM dbo.AspNetUsers
WHERE Email = 'adm@suzd.ru')

--PurchaseRequests
SET @AddedTime = GETDATE()
SET @PurchasePlanId = (SELECT Id
FROM dbo.PurchasePlans
WHERE [Year] = YEAR(GETDATE())
	AND OrganizationId = (SELECT Id
	FROM dbo.AspNetOrganizations
	WHERE [Name] = N'МРСК'))

SET @PurchasePlanYear = (SELECT [Year]
FROM dbo.PurchasePlans
WHERE Id = @PurchasePlanId)
SET @Status = (SELECT Id
FROM dbo.[Status]
WHERE [Name] = 'Draft')
SET @Stage = (SELECT Id
FROM dbo.Stages
WHERE [Name] = 'InclusionToPZ')
SET @IsElectronicPurchase = 1
SET @IsInIpr = 0
SET @IsInBdr = 0
SET @ProductGroupId = 2
SET @ProductTypeId = 1
SET @PlannedSumNotax = 0.00
SET @PlannedSumTax = 0.00
SET @PlannedSumWith30PercReductionNotax = 0.00
SET @PlannedSumWith30PercReductionTax = 0.00
SET @PlannedSumByNotificationNotax = 0.00
SET @PlannedSumByNotificationTax = 0.00
SET @PublicationPlannedDate = GETDATE()
SET @SummingupTime = DATEADD(day,15,GETDATE())
SET @AdditionalPRAttributeId = ( --редактировать вручную
	SELECT TOP(1) Id
	FROM dbo.AdditionalPRAttributes
	WHERE [Description] = N'Дополнительная потребность 3 квартала 2020 года'
		AND OrganisationId = (
			SELECT Id
			FROM dbo.AspNetOrganizations
			WHERE [Name] = N'МРСК'
		)
	)
SET @Okeiguid = (
	SELECT [guid]
	FROM dbo.NsiOkeiItems
	WHERE [name] = N'Условная единица'
    )
SET @Qty = 0.00
SET @IsFixedProcurement = 0
SET @DateApprovalConstructionDocuments = CONVERT(VARCHAR(10),DATEADD(day,-14,GETDATE()),104)
SET @DateEndProject = '0001-01-01 00:00:00.0000000'
SET @CostProject = 0.00
SET @MegaWatt = 0
SET @Mba = 0
SET @Kilometer = 0
SET @ProcessConnection = 0
SET @PrivilegedProcessConnection = 0
SET @ExpWerePpriceNegotiations = 0
SET @ExpWinnerSumOnPpriceNegotiationsNoTax = 0
SET @ExpWinnerSumOnPpriceNegotiationsTax = 0
SET @ExpCountContractorsMspAtWinner = 0
SET @ExpTotalSumContractorsMspAtWinner = 0
SET @ExpSummingupTime = '0001-01-01 00:00:00.0000000'
SET @ExpNumberOfFinalProtocol = ''
SET @ExpDateSendFinalProtocolToProfileDepartmentChief = '0001-01-01 00:00:00.0000000'
SET @ExpDateConclusionContract = '0001-01-01 00:00:00.0000000'
SET @ExpEndDateOfContract = '0001-01-01 00:00:00.0000000'
SET @ExpDateRequestForAdditionalAgreement = '0001-01-01 00:00:00.0000000'
SET @ExpDateReceiptResolutionProtocolCzoAddAgreement = '0001-01-01 00:00:00.0000000'
SET @ExpDateConclusionAdditionalAgreement = '0001-01-01 00:00:00.0000000'
SET @CreatorUserId = ( --редактировать вручную
	SELECT Email
	FROM dbo.AspNetUsers
	WHERE Email = 'import-OLiMTO@mrsk-ural.ru'
	)
SET @OwnerId = (SELECT Id
				FROM dbo.AspNetUsers
				WHERE Email = @CreatorUserId)
SET @OwnerOrganizationId = (SELECT OrganizationId
							FROM dbo.AspNetUsers
							WHERE Email = @CreatorUserId)
SET @Version = 0
SET @IsImported = 1
SET @SapId = N'не пусто!'
SET @ForSmallOrMiddle = 1
SET @ExpEnvelopeOpeningTime = '0001-01-01 00:00:00.0000000'
SET @ExpDateKonProc = '0001-01-01 00:00:00.0000000'
SET @PlannedDateOfCompletion = '0001-01-01 00:00:00.0000000'
SET @PlannedDateOfDelivery = '0001-01-01 00:00:00.0000000'
SET @PlannedDateOfContract = '0001-01-01 00:00:00.0000000'

--AuctionCycles
SET @IsActive = 1
SET @CompletedTime = '0001-01-01 00:00:00.0000000'
SET @DateKonProc = '0001-01-01 00:00:00.0000000'
SET @EnvelopeOpeningTime = '0001-01-01 00:00:00.0000000'
SET @WerePpriceNegotiations = 0
SET @WinnerSumOnPpriceNegotiationsNoTax = 0.00
SET @WinnerSumOnPpriceNegotiationsTax = 0.00
SET @CountContractorsMspAtWinner = 0
SET @TotalSumContractorsMspAtWinner = 0.00
SET @SummingupTime_AC = '0001-01-01 00:00:00.0000000'
SET @FinalSumNoTax = 0.00
SET @FinalSumTax = 0.00
SET @DateSendFinalProtocolToProfileDepartmentChief = '0001-01-01 00:00:00.0000000'
SET @DateConclusionContract = '0001-01-01 00:00:00.0000000'
SET @EndDateOfContract = '0001-01-01 00:00:00.0000000'
SET @DateRequestForAdditionalAgreement = '0001-01-01 00:00:00.0000000'
SET @DateReceiptResolutionProtocolCzoAddAgreement = '0001-01-01 00:00:00.0000000'
SET @DateConclusionAdditionalAgreement = '0001-01-01 00:00:00.0000000'
SET @AddedTime_AC = GETDATE()
SET @ModifiedTime = GETDATE()
SET @Status_AC = 0
SET @Stage_AC = 0
SET @IsLongTermPurchase = 0

--DATA INSERTION PART
--ImportTable
BEGIN
	INSERT INTO @ImportTable
		(
		SapId
		,[Name]
		,CustomerOrganization
		,CustomerSubdivision
		,CustomerFunctionalBlock
		,PlannedPurchaseMethodCode
		,CustomerOrganizer
		,IsElectronicPurchase
		,ForSmallOrMiddle
		,IsInIpr
		,IsInnovation
		,IsONM
		,IsInBdr
		,ProductGroupId --поле убрано из представления заявки АСУЗД
		,ProductTypeId
		,OkvedId
		,OkdpId
		,CodeActivityId
		,PurchaseRequestFinanceSources
		,PurchasePriceDocumentCode
		,PlannedSumNotax
		,PlannedSumTax
		,PlannedSumWith30PercReductionNotax
		,PlannedSumWith30PercReductionTax
		,PlannedSumByNotificationNotax
		,PlannedSumByNotificationTax
		,PublicationPlannedDate
		,PurchaseCategory_Id
		,SummingupTime
		,PlannedPurchaseYear
		,AdditionalInfo
		,Note
		,MinRequirementsForPurchaseGoods
		,Qty
		,Okeiguid
		,Okato
		,PlannedDateOfContract
		,PlannedDateOfDelivery
		,PlannedDateOfCompletion
		,ReasonPurchaseEP
		,ContractorName
		,ContractorInn
		,ContractorKpp
		,IprYear
		,InvestProjectCode
		,InvestProjectName
		,ConstructionDocumentsState
		,DateEndProject
		,CostProject
		,MegaWatt
		,Mba
		,Kilometer
		,ProcessConnection
		,PrivilegedProcessConnection
		)
	SELECT
		[Внутренний id лота]
      , [Наименование лота]
      , [Юридическое лицо]
      , [Филиал/Подразделение]
      , [Функциональный блок]
      , [Планируемый способ закупки]
      , [Организатор закупки]
      , [Вид закупки (электронная/неэлектронная)]
      , [Наличие условий о субъектах малого и среднего предпринимательств]
      , [Является ИПР (Да/Нет)]
      , [Признак закупки инновационной и высокотехнологичной продукции]
	  , [Является ОНМ (Да/Нет)]
      , [В рамках БДР (Да/Нет)]
      , [Группа продукции (Код классификатора)]
      , [Вид закупаемой продукции]
      , [Код по ОКВЭД2]
      , [Код по ОКДП2]
      , [Код вида деятельности]
      , [Источник финансирования]
      , [Документ, на основании которого определена планируемая цена заку]
      , [Планируемая (предельная) цена закупки по ПЗ в текущих ценах, тыс]
      , [Планируемая (предельная) цена закупки по ПЗ в текущих ценах, ты1]
      , [Планируемая (предельная) цена закупки с учетом снижения инвестиц]
      , [Планируемая цена закупки с учетом снижения инвестиционных затрат]
      , [Планируемая начальная (предельная) цена лота по извещению/уведом]
      , [Планируемая начальная (предельная) цена лота по извещению/уведо1]
      , [Плановая дата официального объявления о начале процедур]
      , [Категория закупки]
      , [Плановая дата подведения итогов по закупочной процедуре]
      , [Год под обеспечение потребности которого планируется данная заку]
      , [Дополнительная информация по закупке]
      , [Примечание]
      , [Минимально необходимые требования, предъявляемые к закупаемым то]
      , [Количество]
      , [ЕИ Код по ОКЕИ]
      , [Регион поставки товаров / Наименование ОКАТО]      
      , [Плановая дата заключения договора]
      , [Плановая дата начала поставки товаров, выполнения работ, услуг]
      , [Плановая дата окончания поставки товаров, выполнения работ, услу]
      , [(заполняется только в случае заукпки у ЕП) Основание для проведе]
      , [(заполняется только в случае заукпки у ЕП) Наименование контраге]
      , [(заполняется только в случае закупки у ЕП) ИНН контрагента]
      , [(заполняется только в случае закупки у ЕП) КПП]
      , [ИПР год]
      , [Код объекта в инвестиционной программе]
      , [Наименование инвестиционного проекта]
      , [Дата утверждения проектно-сметной документации]
      , [Ввод объекта в эксплуатацию/ окончание работ по проекту (месяц, ]
      , [Сметная стоимость объекта в тек# ценах, руб# с НДС]
      , [Физические параметры инвестиционного проекта МВт]
      , [Физические параметры инвестиционного проекта MBA]
      , [Физические параметры инвестиционного проекта км]
      , [Технологическое присоединение (Да/Нет)]
      , [Льготное технологическое присоединение (Да/Нет)]
	FROM [dbo].[Sap_Import_20200520]
	--редактировать вручную
	WHERE ([Внутренний id лота] IS NOT NULL)
END

--ITERABLE SUB_INSERTION PART
WHILE (SELECT COUNT(*) FROM @ImportTable) > 0
BEGIN
	INSERT INTO @ImportIdentity
		(Key1, Key2)
	SELECT TOP(1)
		[SapId], [Name]
	FROM @ImportTable

	--Output @ImportIdentity for debugging
	--PRINT @ImportIdentity
	--Reassigning data
	SET @SapId = (SELECT SapId
				  FROM @ImportTable It
				  INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @Name = (SELECT [Name]
				 FROM @ImportTable It
				 INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @CustomerOrganization = (SELECT LOWER(Id)
								FROM dbo.Departments
								WHERE [Type] = 1
									AND [Name] = (SELECT CustomerOrganization
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
								)
	SET @CustomerSubdivision = (SELECT LOWER(Id)
								FROM dbo.Departments
								WHERE [Type] = 2
									AND [Name] LIKE (SELECT
										CASE
										WHEN CustomerSubdivision LIKE N'%Филиал%' 
											THEN '%' + REPLACE(CustomerSubdivision,N'Филиал ','') + '%'
										ELSE CustomerSubdivision
										END
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
										)
								)
	SET @CustomerFunctionalBlock = (
								SELECT LOWER(Id)
								FROM dbo.Departments
								WHERE [Type] = 3
									AND [Name] = (SELECT CustomerFunctionalBlock
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
								)
	SET @PlannedPurchaseMethodCode = (SELECT PlannedPurchaseMethodCode
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @CustomerOrganizer = (SELECT CustomerOrganizer
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @IsElectronicPurchase = (
								SELECT CASE IsElectronicPurchase WHEN N'Да' THEN 1 ELSE 0 END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @ForSmallOrMiddle = (
								SELECT CASE ForSmallOrMiddle WHEN N'нет' THEN 1	WHEN N'да' THEN 2 END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
							)
	SET @IsInnovation = (
								SELECT CASE IsInnovation WHEN N'Нет' THEN 0 ELSE 1 END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @IsInIpr = (
								SELECT CASE IsInIpr WHEN N'Нет' THEN 0 WHEN N'Да' THEN 1 END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @IsONM = (
								SELECT CASE IsONM WHEN N'Нет' THEN 0 ELSE 1 END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @IsInBdr = (
								SELECT CASE IsInBdr WHEN N'Да' THEN 1 ELSE 0 END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @ProductTypeId = (
								SELECT Id
								FROM dbo.NsiProductTypes
								WHERE Code = (SELECT ProductTypeId
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
								)
	SET @OkvedId = (
								SELECT Id
								FROM dbo.NsiOkved2Item
								WHERE actual = 1
									AND code = (SELECT OkvedId
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
								)
	SET @OkdpId = (
								SELECT id
								FROM dbo.NsiOkdp2Item
								WHERE actual = 1
									AND code = (SELECT OkdpId
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
								)
	SET @CodeActivityId = (
								SELECT Id
								FROM dbo.NsiCodeActivities
								WHERE MayBeSelected = 1 AND IsEnabled = 1
									AND Code = (
																		SELECT LEFT(CodeActivityId,CHARINDEX('-',CodeActivityId)-1)
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
																		)								
								)
	SET @PurchasePriceDocumentCode = (
								SELECT Code
								FROM dbo.NsiPurchasePriceDocuments
								WHERE [Name] = (
																	SELECT REPLACE(REPLACE(PurchasePriceDocumentCode,N'"МРСК',N'«МРСК'),N'Урала"',N'Урала»')
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
																	)								
								)
	SET @PlannedSumNotax = (
								SELECT
								CASE
									WHEN PlannedSumNotax IS NULL THEN CAST(0.00 AS decimal(18,2))
									ELSE CAST(PlannedSumNotax AS decimal(18,2)) 
								END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @PlannedSumTax = (
								SELECT
								CASE
									WHEN PlannedSumTax IS NULL THEN CAST(0.00 AS decimal(18,2))
									ELSE CAST(PlannedSumTax AS decimal(18,2))
								END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @PlannedSumWith30PercReductionNotax = (
									SELECT
										CASE 
											WHEN PlannedSumWith30PercReductionNotax IS NULL THEN CAST(0.00 AS decimal(18,2))
											ELSE CAST(PlannedSumWith30PercReductionNotax AS decimal(18,2))
										END
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
									)
	SET @PlannedSumWith30PercReductionTax = (									
									SELECT
										CASE 
											WHEN PlannedSumWith30PercReductionTax IS NULL THEN CAST(0.00 AS decimal(18,2))
											ELSE CAST(PlannedSumWith30PercReductionTax AS decimal(18,2))
										END
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
									)
	SET @PlannedSumByNotificationNotax = (
									SELECT
										CASE 
											WHEN PlannedSumByNotificationNotax IS NULL THEN CAST(0.00 AS decimal(18,2))
											ELSE CAST(PlannedSumByNotificationNotax AS decimal(18,2))
										END
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
									)
	SET @PlannedSumByNotificationTax = (
									SELECT
										CASE
											WHEN PlannedSumByNotificationTax IS NULL THEN CAST(0.00 AS decimal(18,2))
											ELSE CAST(PlannedSumByNotificationTax AS decimal(18,2))
										END
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
									)
	SET @PublicationPlannedDate = (SELECT CAST(PublicationPlannedDate AS datetime2(7))
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @PurchaseCategory_Id = (
										SELECT Id
										FROM dbo.NsiPurchaseCategories
										WHERE MayBeSelected = 1 AND IsEnabled = 1
											AND [Name] = (SELECT PurchaseCategory_Id
											FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
									)
	SET @SummingupTime = (SELECT CAST(SummingupTime AS datetime2(7))
							FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @PlannedPurchaseYear = (SELECT PlannedPurchaseYear
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @AdditionalInfo = (SELECT AdditionalInfo
							FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @Note = (SELECT Note
					FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @MinRequirementsForPurchaseGoods = (
									SELECT Code
									FROM dbo.NsiRequirementsForPurchaseGoods
									WHERE [Name] = (SELECT MinRequirementsForPurchaseGoods
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
									)
	SET @Qty = (SELECT CAST(Qty AS decimal(18,2))
				FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @Okeiguid = (SELECT TOP(1)		[guid]
					FROM dbo.NsiOkeiItems
					WHERE actual = 1
						AND code = (SELECT
										CASE
											WHEN LEN(CAST(Okeiguid AS nvarchar(max))) = 1 THEN '00' + CAST(Okeiguid AS nvarchar(max))
											WHEN LEN(CAST(Okeiguid AS nvarchar(max))) = 2 THEN '0' + CAST(Okeiguid AS nvarchar(max))
											ELSE CAST(Okeiguid AS nvarchar(max))
										END
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
																)
									)
	SET @Okato = (					
									SELECT code
									FROM dbo.NsiOkatoItems
									WHERE [Name] = (SELECT Okato
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
																	)
	SET @PlannedDateOfContract = (SELECT CAST(PlannedDateOfContract AS datetime2(7))
									FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @PlannedDateOfDelivery = (SELECT CAST(PlannedDateOfDelivery AS datetime2(7))
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @PlannedDateOfCompletion = (SELECT CAST(PlannedDateOfCompletion AS datetime2(7))
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @ReasonPurchaseEP = (SELECT ReasonPurchaseEP
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @ContractorName = (SELECT ContractorName
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @ContractorInn = (SELECT ContractorInn
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @ContractorKpp = (SELECT ContractorKpp
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @IprYear = (SELECT IprYear
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @InvestProjectCode = (SELECT InvestProjectCode
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))
	SET @InvestProjectName = (SELECT InvestProjectName
										FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name]))

	IF (SELECT ConstructionDocumentsState
		FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])) = N'Не требуется'
			BEGIN
				SET @DateApprovalConstructionDocuments = NULL
				SET @IsApprovedConstructionDocuments = 0
				SET @IsNeedConstructionDocuments = 1
			END
	ELSE
		BEGIN
		SET @DateApprovalConstructionDocuments = CONVERT(VARCHAR(10),DATEADD(day,-14,GETDATE()),104)
		SET @IsApprovedConstructionDocuments = 0
		SET @IsNeedConstructionDocuments = 0
	END

	SET @DateEndProject = (
								SELECT CASE WHEN DateEndProject IS NULL THEN CAST('0001-01-01 00:00:00.0000000' AS datetime2(7)) END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @CostProject = (
								SELECT
									CASE
										WHEN CostProject IS NULL THEN CAST(0.00 AS decimal(18,2))
										ELSE CAST(CostProject AS decimal(18,2))
									END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @MegaWatt = (
								SELECT
								CASE 
									WHEN MegaWatt IS NULL THEN CAST(0 AS decimal(18,4))
									ELSE CAST(MegaWatt AS decimal(18,4))
								END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @Mba = (								
								SELECT
								CASE 
									WHEN Mba IS NULL THEN CAST(0 AS decimal(18,4))
									ELSE CAST(Mba AS decimal(18,4))
								END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @Kilometer = (
								SELECT
								CASE 
									WHEN Kilometer IS NULL THEN CAST(0 AS decimal(18,4))
									ELSE CAST(Kilometer AS decimal(18,4))
								END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @ProcessConnection = (
								SELECT
								CASE
									WHEN ProcessConnection = N'Да' THEN 1
									ELSE 0
								END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)
	SET @PrivilegedProcessConnection = (
								SELECT
								CASE 
									WHEN PrivilegedProcessConnection = N'Да' THEN 1
									ELSE 0									
								END
								FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
								)

	--PurchaseRequests
	INSERT INTO dbo.Purchaserequests
		(
		AddedTime
		,PurchasePlanId
		,PurchasePlanYear
		,Status
		,Stage
		,IsElectronicPurchase
		,IsInIpr
		,IsInBdr
		,ProductGroupId
		,ProductTypeId
		,PlannedSumNotax
		,PlannedSumTax
		,PlannedSumWith30PercReductionNotax
		,PlannedSumWith30PercReductionTax
		,PlannedSumByNotificationNotax
		,PlannedSumByNotificationTax
		,PublicationPlannedDate
		,SummingupTime
		,AdditionalPRAttributeId
		,Okeiguid
		,Qty
		,IsFixedProcurement
		,DateApprovalConstructionDocuments
		,DateEndProject
		,CostProject
		,MegaWatt
		,Mba
		,Kilometer
		,ProcessConnection
		,PrivilegedProcessConnection
		,ExpWerePpriceNegotiations
		,ExpWinnerSumOnPpriceNegotiationsNoTax
		,ExpWinnerSumOnPpriceNegotiationsTax
		,ExpCountContractorsMspAtWinner
		,ExpTotalSumContractorsMspAtWinner
		,ExpSummingupTime
		,ExpNumberOfFinalProtocol
		,ExpDateSendFinalProtocolToProfileDepartmentChief
		,ExpDateConclusionContract
		,ExpEndDateOfContract
		,ExpDateRequestForAdditionalAgreement
		,ExpDateReceiptResolutionProtocolCzoAddAgreement
		,ExpDateConclusionAdditionalAgreement
		,CreatorUserId
		,OwnerId
		,OwnerOrganizationId
		,Version
		,IsImported
		,SapId
		,ForSmallOrMiddle
		,ExpEnvelopeOpeningTime
		,ExpDateKonProc
		,PlannedDateOfCompletion
		,PlannedDateOfDelivery
		,PlannedDateOfContract
		,Name
		,CustomerOrganization
		,CustomerSubdivision
		,CustomerFunctionalBlock
		,PlannedPurchaseMethodCode
		,CustomerOrganizer
		,IsInnovation
		,IsONM
		,OkvedId
		,OkdpId
		,CodeActivityId
		,PurchasePriceDocumentCode
		,PurchaseCategory_Id
		,PlannedPurchaseYear
		,AdditionalInfo
		,Note
		,MinRequirementsForPurchaseGoods
		,Okato
		,ReasonPurchaseEP
		,ContractorName
		,ContractorInn
		,Kpp
		,IprYear
		,InvestProjectCode
		,InvestProjectName
		,IsApprovedConstructionDocuments
		,IsNeedConstructionDocuments
		)
	VALUES
		(
		  @AddedTime
		, @PurchasePlanId
		, @PurchasePlanYear
		, @Status
		, @Stage
		, @IsElectronicPurchase
		, @IsInIpr
		, @IsInBdr
		, @ProductGroupId
		, @ProductTypeId
		, @PlannedSumNotax
		, @PlannedSumTax
		, @PlannedSumWith30PercReductionNotax
		, @PlannedSumWith30PercReductionTax
		, @PlannedSumByNotificationNotax
		, @PlannedSumByNotificationTax
		, @PublicationPlannedDate
		, @SummingupTime
		, @AdditionalPRAttributeId
		, @Okeiguid
		, @Qty
		, @IsFixedProcurement
		, @DateApprovalConstructionDocuments
		, @DateEndProject
		, @CostProject
		, @MegaWatt
		, @Mba
		, @Kilometer
		, @ProcessConnection
		, @PrivilegedProcessConnection
		, @ExpWerePpriceNegotiations
		, @ExpWinnerSumOnPpriceNegotiationsNoTax
		, @ExpWinnerSumOnPpriceNegotiationsTax
		, @ExpCountContractorsMspAtWinner
		, @ExpTotalSumContractorsMspAtWinner
		, @ExpSummingupTime
		, @ExpNumberOfFinalProtocol
		, @ExpDateSendFinalProtocolToProfileDepartmentChief
		, @ExpDateConclusionContract
		, @ExpEndDateOfContract
		, @ExpDateRequestForAdditionalAgreement
		, @ExpDateReceiptResolutionProtocolCzoAddAgreement
		, @ExpDateConclusionAdditionalAgreement
		, @CreatorUserId
		, @OwnerId
		, @OwnerOrganizationId
		, @Version
		, @IsImported
		, @SapId
		, @ForSmallOrMiddle
		, @ExpEnvelopeOpeningTime
		, @ExpDateKonProc
		, @PlannedDateOfCompletion
		, @PlannedDateOfDelivery
		, @PlannedDateOfContract
		, @Name
		, @CustomerOrganization
		, @CustomerSubdivision
		, @CustomerFunctionalBlock
		, @PlannedPurchaseMethodCode
		, @CustomerOrganizer
		, @IsInnovation
		, @IsONM
		, @OkvedId
		, @OkdpId
		, @CodeActivityId
		, @PurchasePriceDocumentCode
		, @PurchaseCategory_Id
		, @PlannedPurchaseYear
		, @AdditionalInfo
		, @Note
		, @MinRequirementsForPurchaseGoods
		, @Okato
		, @ReasonPurchaseEP
		, @ContractorName
		, @ContractorInn
		, @ContractorKpp
		, @IprYear
		, @InvestProjectCode
		, @InvestProjectName
		, @IsApprovedConstructionDocuments
		, @IsNeedConstructionDocuments
	)
	SET @RequestId = SCOPE_IDENTITY()

	--PurchaseRequestFinanceSource
	INSERT INTO @PurchaseRequestFinanceSources
	SELECT PurchaseRequestFinanceSources
	FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])

	;WITH
		FSnames(DataItem, String)
		AS
		(
				SELECT
					LTRIM(LEFT(String, CHARINDEX(',', String + ',') - 1)),
					LTRIM(STUFF(String, 1, CHARINDEX(',', String + ','), ''))
				FROM @PurchaseRequestFinanceSources
			UNION ALL

				SELECT
					LTRIM(LEFT(String, CHARINDEX(',', String + ',') - 1)),
					LTRIM(STUFF(String, 1, CHARINDEX(',', String + ','), ''))
				FROM FSnames
				WHERE
			String > ''
		)
	INSERT INTO dbo.PurchaseRequestFinanceSource
	SELECT @RequestId, FS.Id
	FROM dbo.NsiFinanceSources AS FS
		INNER JOIN FSnames ON FSnames.DataItem = FS.[Name]
	WHERE FS.IsEnabled = 1 AND FS.MayBeSelected = 1

	DELETE FROM @PurchaseRequestFinanceSources

	--AuctionCycles
	INSERT INTO dbo.AuctionCycles
		(
		RequestId
		,IsActive
		,CompletedTime
		,DateKonProc
		,EnvelopeOpeningTime
		,WerePpriceNegotiations
		,WinnerSumOnPpriceNegotiationsNoTax
		,WinnerSumOnPpriceNegotiationsTax
		,CountContractorsMspAtWinner
		,TotalSumContractorsMspAtWinner
		,SummingupTime
		,FinalSumNoTax
		,FinalSumTax
		,DateSendFinalProtocolToProfileDepartmentChief
		,DateConclusionContract
		,EndDateOfContract
		,DateRequestForAdditionalAgreement
		,DateReceiptResolutionProtocolCzoAddAgreement
		,DateConclusionAdditionalAgreement
		,AddedTime
		,ModifiedTime
		,Status
		,Stage
		,IsLongTermPurchase
		)
	VALUES
		(
			@RequestId
		, @IsActive
		, @CompletedTime
		, @DateKonProc
		, @EnvelopeOpeningTime
		, @WerePpriceNegotiations
		, @WinnerSumOnPpriceNegotiationsNoTax
		, @WinnerSumOnPpriceNegotiationsTax
		, @CountContractorsMspAtWinner
		, @TotalSumContractorsMspAtWinner
		, @SummingupTime_AC
		, @FinalSumNoTax
		, @FinalSumTax
		, @DateSendFinalProtocolToProfileDepartmentChief
		, @DateConclusionContract
		, @EndDateOfContract
		, @DateRequestForAdditionalAgreement
		, @DateReceiptResolutionProtocolCzoAddAgreement
		, @DateConclusionAdditionalAgreement
		, @AddedTime_AC
		, @ModifiedTime
		, @Status_AC
		, @Stage_AC
		, @IsLongTermPurchase
	)
	SET @AuctionCycleId = SCOPE_IDENTITY()

	--/* Нужно переписать алгоритм чтобы раскидывал равномерно по периодам
	--LongTermPurschasePayments		
	IF YEAR(@PublicationPlannedDate) < YEAR(@PlannedDateOfDelivery)
		BEGIN
		SET @PaymentYearIterator = YEAR(@PublicationPlannedDate)
		WHILE @PaymentYearIterator <= YEAR(@PlannedDateOfDelivery)
			BEGIN
			INSERT INTO dbo.LongTermPurschasePayments
				(AuctionCycleId, PaymentYear, PaymentSummWithTax)
			(
					SELECT
				@AuctionCycleId
						, @PaymentYearIterator
						, CASE
							WHEN YEAR(@PlannedDateOfDelivery) = @PaymentYearIterator
								THEN @PlannedSumByNotificationTax
							ELSE CAST(0.00 AS decimal(18,2))
						END					
				)
			SET @PaymentYearIterator = @PaymentYearIterator + 1
		END
	END
	--*/

	--audit
	EXECUTE sp_AddAuditItemRequest @AddedTime,@WhoMakesImport,@RequestId,@AuditMessage

	--decrement
	BEGIN
		DELETE It FROM @ImportTable It INNER JOIN @ImportIdentity Ii ON (Ii.Key1 = It.SapId) AND (Ii.Key2 = It.[Name])
		DELETE FROM @ImportIdentity
	END
END


SELECT top 56 *
  FROM [dbo].[PurchaseRequests]
  --where SapId is not null
  order by id desc

 -- select * 
	--FROM dbo.PurchaseRequests
	--where id in (23205, 23206)

ROLLBACK TRAN
--</0_импорт>*/
