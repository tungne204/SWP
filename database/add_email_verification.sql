-- Add email verification fields to User table
USE SWP391;
GO

-- Add email_verification_code column if not exists
IF NOT EXISTS (SELECT * FROM sys.columns WHERE name = 'email_verification_code' AND object_id = OBJECT_ID('dbo.User'))
BEGIN
    ALTER TABLE [dbo].[User]
    ADD email_verification_code NVARCHAR(10) NULL,
        email_verification_expiry DATETIME NULL,
        email_verified BIT NOT NULL DEFAULT 0;
    
    PRINT '✅ Email verification fields added successfully!';
END
ELSE
BEGIN
    PRINT '⚠️ Email verification fields already exist!';
END
GO

