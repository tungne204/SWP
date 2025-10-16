-- Purpose: Allow multiple NULLs in dbo.Patient.user_id while preserving
--          uniqueness for non-NULL values.
-- Approach: Drop the existing UNIQUE constraint on user_id and create
--           a filtered UNIQUE index for user_id IS NOT NULL.

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @TableObjectId INT = OBJECT_ID(N'dbo.Patient');
    DECLARE @UserIdColumnId INT = COLUMNPROPERTY(@TableObjectId, 'user_id', 'ColumnID');
    DECLARE @ConstraintName SYSNAME;

    -- Find the UNIQUE constraint on dbo.Patient(user_id)
    SELECT TOP 1 @ConstraintName = kc.name
    FROM sys.key_constraints kc
    JOIN sys.indexes i
      ON kc.parent_object_id = i.object_id
     AND kc.unique_index_id = i.index_id
    JOIN sys.index_columns ic
      ON i.object_id = ic.object_id
     AND i.index_id = ic.index_id
    WHERE kc.parent_object_id = @TableObjectId
      AND kc.type = 'UQ'
    GROUP BY kc.name
    HAVING COUNT(*) = 1
       AND SUM(CASE WHEN ic.column_id = @UserIdColumnId THEN 1 ELSE 0 END) = 1;

    IF @ConstraintName IS NOT NULL
    BEGIN
        DECLARE @sql NVARCHAR(4000) =
            N'ALTER TABLE [dbo].[Patient] DROP CONSTRAINT [' + @ConstraintName + N']';
        PRINT N'Dropping UNIQUE constraint: ' + @ConstraintName;
        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        PRINT N'No UNIQUE constraint found on dbo.Patient(user_id); skipping drop.';
    END

    -- Create filtered unique index to enforce uniqueness only for non-NULL user_id values
    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE object_id = @TableObjectId
          AND name = N'UX_Patient_UserId_NotNull'
    )
    BEGIN
        PRINT N'Creating filtered UNIQUE index: UX_Patient_UserId_NotNull';
        CREATE UNIQUE NONCLUSTERED INDEX [UX_Patient_UserId_NotNull]
            ON [dbo].[Patient] ([user_id])
            WHERE [user_id] IS NOT NULL;
    END
    ELSE
    BEGIN
        PRINT N'Filtered UNIQUE index UX_Patient_UserId_NotNull already exists; skipping create.';
    END

    COMMIT TRAN;
    PRINT N'Update completed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrNum INT = ERROR_NUMBER();
    PRINT N'Update failed. Error ' + CAST(@ErrNum AS NVARCHAR(20)) + N': ' + @ErrMsg;
    THROW;
END CATCH;