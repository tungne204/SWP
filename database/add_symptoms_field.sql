-- Add symptoms field to Appointment table
ALTER TABLE [dbo].[Appointment]
ADD [symptoms] [nvarchar](max) NULL;
GO

