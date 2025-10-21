-- Script to modify the Patient table to allow NULL values for user_id
-- This will allow direct check-ins without requiring a User record

USE SWP02;
GO

-- Check if the constraint exists and drop it
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK__Patient__user_id__5FB337D6')
BEGIN
    ALTER TABLE [dbo].[Patient] DROP CONSTRAINT [FK__Patient__user_id__5FB337D6];
    PRINT '✅ Foreign key constraint dropped successfully!';
END
ELSE
BEGIN
    PRINT '⚠️ Foreign key constraint does not exist!';
END
GO

-- Modify the user_id column to allow NULL values
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Patient') AND name = 'user_id' AND is_nullable = 0)
BEGIN
    ALTER TABLE [dbo].[Patient] ALTER COLUMN [user_id] INT NULL;
    PRINT '✅ user_id column modified to allow NULL values!';
END
ELSE
BEGIN
    PRINT '⚠️ user_id column already allows NULL values or does not exist!';
END
GO

-- Add a new constraint that allows NULL values
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Patient_User')
BEGIN
    ALTER TABLE [dbo].[Patient] 
    ADD CONSTRAINT [FK_Patient_User] 
    FOREIGN KEY ([user_id]) REFERENCES [User]([user_id]) 
    ON DELETE SET NULL ON UPDATE CASCADE;
    PRINT '✅ New foreign key constraint added with SET NULL on delete!';
END
ELSE
BEGIN
    PRINT '⚠️ New foreign key constraint already exists!';
END
GO