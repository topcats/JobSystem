SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[JobComplete]
    @RunID          int,
    @HostMachine    varchar(50),
    @HostInstance   varchar(50),
    @ProcessLog     text,
    @Result         varchar(10)
    AS
    SET @HostMachine = UPPER(@HostMachine)

    BEGIN TRAN
    
    SET NOCOUNT ON

    UPDATE [dbo].[RunHistory]
    SET 
        [StopTime] = sysutcdatetime(),
        [ProcessLog] = @ProcessLog,
        [Result] = @Result
    WHERE
        ([RunID] = @RunID)
        AND ([HostMachine] = @HostMachine)
        AND ([HostInstance] = @HostInstance)

    COMMIT

    RETURN 0
GO
