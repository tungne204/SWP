-- Script to modify the PatientQueue table to allow NULL values for patient_id
-- This will allow direct check-ins without requiring a Patient record

USE SWP02;
GO

-- Check if the constraint exists and drop it
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PatientQueue_Patient')
BEGIN
    ALTER TABLE [dbo].[PatientQueue] DROP CONSTRAINT [FK_PatientQueue_Patient];
    PRINT '✅ Foreign key constraint dropped successfully!';
END
ELSE
BEGIN
    PRINT '⚠️ Foreign key constraint does not exist!';
END
GO

-- Modify the patient_id column to allow NULL values
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.PatientQueue') AND name = 'patient_id' AND is_nullable = 0)
BEGIN
    ALTER TABLE [dbo].[PatientQueue] ALTER COLUMN [patient_id] INT NULL;
    PRINT '✅ patient_id column modified to allow NULL values!';
END
ELSE
BEGIN
    PRINT '⚠️ patient_id column already allows NULL values or does not exist!';
END
GO

-- Add a new constraint that allows NULL values
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PatientQueue_Patient')
BEGIN
    ALTER TABLE [dbo].[PatientQueue] 
    ADD CONSTRAINT [FK_PatientQueue_Patient] 
    FOREIGN KEY ([patient_id]) REFERENCES [Patient]([patient_id]) 
    ON DELETE SET NULL ON UPDATE CASCADE;
    PRINT '✅ New foreign key constraint added with SET NULL on delete!';
END
ELSE
BEGIN
    PRINT '⚠️ New foreign key constraint already exists!';
END
GO