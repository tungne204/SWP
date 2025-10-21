-- Script tạo bảng User cho hệ thống Medilab
-- Chạy script này trong SQL Server Management Studio

USE SWP02;
GO

-- Tạo bảng User nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='User' AND xtype='U')
BEGIN
    CREATE TABLE [User] (
        user_id INT IDENTITY(1,1) PRIMARY KEY,
        username NVARCHAR(100) NOT NULL,
        password NVARCHAR(255) NOT NULL,
        email NVARCHAR(255) UNIQUE NOT NULL,
        phone NVARCHAR(20),
        role_id INT NOT NULL DEFAULT 3,
        status BIT NOT NULL DEFAULT 1,
        created_date DATETIME DEFAULT GETDATE(),
        updated_date DATETIME DEFAULT GETDATE()
    );
    
    PRINT '✅ Bảng User đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT '⚠️ Bảng User đã tồn tại!';
END
GO

-- Tạo bảng Role nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Role' AND xtype='U')
BEGIN
    CREATE TABLE [Role] (
        role_id INT IDENTITY(1,1) PRIMARY KEY,
        role_name NVARCHAR(50) NOT NULL,
        description NVARCHAR(255)
    );
    
    -- Thêm dữ liệu mẫu cho Role
    INSERT INTO [Role] (role_name, description) VALUES 
    ('Admin', 'Quản trị viên hệ thống'),
    ('Doctor', 'Bác sĩ'),
    ('Patient', 'Bệnh nhân'),
    ('MedicalAssistant', 'Y tá/Trợ lý y tế'),
    ('Receptionist', 'Lễ tân');
    
    PRINT '✅ Bảng Role đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT '⚠️ Bảng Role đã tồn tại!';
END
GO

-- Thêm foreign key constraint nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_User_Role')
BEGIN
    ALTER TABLE [User] 
    ADD CONSTRAINT FK_User_Role 
    FOREIGN KEY (role_id) REFERENCES [Role](role_id);
    
    PRINT '✅ Foreign key constraint đã được thêm!';
END
ELSE
BEGIN
    PRINT '⚠️ Foreign key constraint đã tồn tại!';
END
GO

-- Kiểm tra dữ liệu
SELECT 'User Table Structure:' as Info;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'User';

SELECT 'Role Data:' as Info;
SELECT * FROM [Role];

SELECT 'User Count:' as Info;
SELECT COUNT(*) as TotalUsers FROM [User];
GO
