SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[JobTask](
    [JobMasterID]   [uniqueidentifier]  NOT NULL,
    [RunOrder]      [int]               NOT NULL,
    [Name]          [varchar](50)       NOT NULL,
    [ActionTypeID]  [int]               NOT NULL,
    [Enabled]       [bit]               NOT NULL,
    [Updated]       [datetime]          NOT NULL,
    [Script]        [text]              NOT NULL,
    [RunCredentials] [varchar](max)     NULL,
 CONSTRAINT [PK_JobTask] PRIMARY KEY CLUSTERED 
(
    [JobMasterID] ASC,
    [RunOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[JobTask] ADD  CONSTRAINT [DF_JobTask_Enabled]  DEFAULT ((0)) FOR [Enabled]
GO

ALTER TABLE [dbo].[JobTask] ADD  CONSTRAINT [DF_JobTask_Updated]  DEFAULT (sysutcdatetime()) FOR [Updated]
GO

ALTER TABLE [dbo].[JobTask]  WITH CHECK ADD  CONSTRAINT [FK_JobTask_ActionType] FOREIGN KEY([ActionTypeID])
REFERENCES [dbo].[ActionType] ([ID])
GO

ALTER TABLE [dbo].[JobTask] CHECK CONSTRAINT [FK_JobTask_ActionType]
GO

ALTER TABLE [dbo].[JobTask]  WITH CHECK ADD  CONSTRAINT [FK_JobTask_JobMaster] FOREIGN KEY([JobMasterID])
REFERENCES [dbo].[JobMaster] ([ID])
GO

ALTER TABLE [dbo].[JobTask] CHECK CONSTRAINT [FK_JobTask_JobMaster]
GO
