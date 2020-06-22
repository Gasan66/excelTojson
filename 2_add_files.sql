use asuzd
--<2_тиражирование файлов>
BEGIN TRANSACTION FileTiraging
DECLARE @PRidToCopyFilesFrom bigint = 24161 --!!!! редактировать вручную, загрузить нужные файлы в заявку !!!!
DECLARE @FileDatas AS TABLE 
	(
    [Name] nvarchar(max),
    ContentType nvarchar(max),
    Size bigint,
    [Data] varbinary(max),
    AddedTime datetime2(7)
	)
INSERT INTO @FileDatas
SELECT FD.[Name], FD.[ContentType], FD.[Size], FD.[Data], FD.[AddedTime]
FROM dbo.RequestFiles RF
    LEFT JOIN dbo.FileDatas FD ON FD.Id = RF.Data_Id
WHERE RF.RequestId = @PRidToCopyFilesFrom

DECLARE @FileDatasScopeIdentity AS TABLE (Id varchar(128))
DECLARE @PRids TABLE (Id bigint)
;
WITH
    Import
    AS
    (
        SELECT AiR.PurchaseRequestId
        FROM dbo.AuditItems Ai
            LEFT JOIN dbo.AuditItemRequests AiR ON AiR.ItemId = Ai.Id
        WHERE AI.[Message] LIKE N'Импортировано 2020.05.20 21:24:47%' -- !!!! редактировать вручную !!!!
            AND AiR.PurchaseRequestId != @PRidToCopyFilesFrom
    )
INSERT INTO @PRids
SELECT PurchaseRequestId
FROM Import

DECLARE @PRid bigint

WHILE (SELECT COUNT(*) FROM @PRids) > 0
BEGIN
    SET @PRid = (SELECT TOP(1) Id FROM @PRids)

    INSERT INTO dbo.FileDatas
        ([Name],ContentType,Size,[Data],AddedTime)
    OUTPUT	
		INSERTED.Id INTO @FileDatasScopeIdentity (Id)
    SELECT * FROM @FileDatas

    INSERT INTO dbo.RequestFiles
        (RequestId,[Type],[Version],Data_Id)
    SELECT @PRid, 0, 1, Id
    FROM @FileDatasScopeIdentity

    DELETE FROM @FileDatasScopeIdentity

    PRINT N'файлы из заявки ' + CAST(@PRidToCopyFilesFrom AS nvarchar(50)) + N' скопированы в заявку ' + CAST(@PRid AS nvarchar(50))
    DELETE FROM @PRids WHERE Id = @PRid
END

ROLLBACK
--</2_тиражирование файлов>
