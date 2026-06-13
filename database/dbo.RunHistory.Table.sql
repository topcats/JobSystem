SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RunHistory](
    [RunID]         [int] IDENTITY(1,1) NOT NULL,
    [JobMasterID]   [uniqueidentifier]  NOT NULL,
    [StartTime]     [datetime2](7)      NULL,
    [StopTime]      [datetime2](7)      NULL,
    [HostMachine]   [varchar](50)       NULL,
    [ProcessLog]    [text]              NULL,
    [Result]        [nchar](10)         NULL,
 CONSTRAINT [PK_RunHistory] PRIMARY KEY CLUSTERED 
(
    [RunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[RunHistory]  WITH CHECK ADD  CONSTRAINT [FK_RunHistory_JobMaster] FOREIGN KEY([JobMasterID])
REFERENCES [dbo].[JobMaster] ([ID])
GO

ALTER TABLE [dbo].[RunHistory] CHECK CONSTRAINT [FK_RunHistory_JobMaster]
GO


