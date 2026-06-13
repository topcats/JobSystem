SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[JobMaster](
    [ID]            [uniqueidentifier]  NOT NULL,
    [Name]          [varchar](50)       NOT NULL,
    [Enabled]       [bit]               NOT NULL,
    [Updated]       [datetime]          NOT NULL,
 CONSTRAINT [PK_JobMaster] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[JobMaster] ADD  CONSTRAINT [DF_JobMaster_Enabled]  DEFAULT ((0)) FOR [Enabled]
GO

ALTER TABLE [dbo].[JobMaster] ADD  CONSTRAINT [DF_JobMaster_Updated]  DEFAULT (sysutcdatetime()) FOR [Updated]
GO
