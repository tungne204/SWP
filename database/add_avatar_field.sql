-- Script thêm trường avatar vào bảng User
-- Chạy script này trong SQL Server Management Studio

USE SWP02;
GO

-- Kiểm tra xem trường avatar đã tồn tại chưa
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'User' AND COLUMN_NAME = 'avatar')
BEGIN
    -- Thêm trường avatar vào bảng User
    ALTER TABLE [User] 
    ADD avatar NVARCHAR(500) NULL;
    
    PRINT '✅ Trường avatar đã được thêm vào bảng User thành công!';
    
    -- Cập nhật một số user mẫu với avatar mặc định
    UPDATE [User] 
    SET avatar = 'assets/img/default-avatar.png'
    WHERE avatar IS NULL;
    
    PRINT '✅ Đã cập nhật avatar mặc định cho các user hiện có!';
END
ELSE
BEGIN
    PRINT '⚠️ Trường avatar đã tồn tại trong bảng User!';
END
GO

-- Kiểm tra cấu trúc bảng User sau khi thêm
SELECT 'User Table Structure After Adding Avatar:' as Info;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'User'
ORDER BY ORDINAL_POSITION;

-- Hiển thị một số user mẫu để kiểm tra
SELECT 'Sample Users with Avatar:' as Info;
SELECT TOP 5 user_id, username, email, avatar 
FROM [User];
GO

