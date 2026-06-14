SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[StartJob]
    @JobMasterID    uniqueidentifier,
    @HostMachine    varchar(50),
    @HostInstance   varchar(50),
    @RunID          int OUTPUT
    AS
    SET @HostMachine = UPPER(@HostMachine)

    BEGIN TRAN

    SET NOCOUNT ON

    DECLARE @cTaskName varchar(50), @cStartTime datetime, @cCompleteTime datetime

SELECT [JobMaster].[ID],[JobMaster].[Name],[JobMaster].[Enabled]
FROM [dbo].[JobMaster]
LEFT OUTER JOIN [dbo].[RunSchedule] ON RunSchedule.JobMasterID = JobMaster.ID
WHERE ([JobMaster].[Enabled] = 1)



    SELECT @cTaskName = [TaskName], @cStartTime = [StartTime], @cCompleteTime = [CompleteTime]
    FROM [dbo].[SchedulerTask] WITH (TABLOCKX)
    WHERE ([TaskName] = @TaskName)

    IF @cTaskName IS NULL
    BEGIN
        -- Never Run before
        INSERT [dbo].[SchedulerTask]
            ([TaskName]
            ,[StartTime]
            ,[RunServer]
            ,[RunInstance])
        VALUES
            (@TaskName
            ,GETDATE()
            ,@RunServer
            ,@RunInstance)

        SET @Allowed = 1

    END ELSE BEGIN

        IF ((@cCompleteTime IS NOT NULL) AND (DATEDIFF(MINUTE, ISNULL(@cCompleteTime, GETDATE()), GETDATE()) > 5)) OR (DATEDIFF(HOUR, ISNULL(@cStartTime, GETDATE()), GETDATE()) > 20)
        BEGIN
            -- Complete or failed
            UPDATE [dbo].[SchedulerTask]
            SET 
                [StartTime] = GETDATE()
                ,[RunServer] = @RunServer
                ,[RunInstance] = @RunInstance
                ,[CompleteTime] = NULL
            WHERE
                ([TaskName] = @TaskName)

            SET @Allowed = 1
        END ELSE BEGIN
            -- Not allowed as running
            SET @Allowed = 0
        END
    END

    COMMIT

    RETURN 0
GO
