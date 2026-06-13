SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RunSchedule](
    [ScheduleID]    [int] IDENTITY(1,1) NOT NULL,
    [JobMasterID]   [uniqueidentifier]  NOT NULL,
    [Enabled]       [bit]               NOT NULL,
    [RunOnce]       [datetime]          NULL,
    [RunDay]        [int]               NULL,
    [RunTime]       [datetime]          NULL,
    [StartDate]     [datetime]          NULL,
    [EndDate]       [datetime]          NULL,
    [Updated]       [datetime]          NOT NULL,
 CONSTRAINT [PK_RunSchedule] PRIMARY KEY CLUSTERED 
(
    [ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RunSchedule] ADD  CONSTRAINT [DF_RunSchedule_Enabled]  DEFAULT ((0)) FOR [Enabled]
GO

ALTER TABLE [dbo].[RunSchedule] ADD  CONSTRAINT [DF_RunSchedule_Updated]  DEFAULT (sysutcdatetime()) FOR [Updated]
GO

ALTER TABLE [dbo].[RunSchedule]  WITH CHECK ADD  CONSTRAINT [FK_RunSchedule_JobMaster] FOREIGN KEY([JobMasterID])
REFERENCES [dbo].[JobMaster] ([ID])
GO

ALTER TABLE [dbo].[RunSchedule] CHECK CONSTRAINT [FK_RunSchedule_JobMaster]
GO
