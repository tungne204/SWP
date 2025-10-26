-- Authorization Management Database Schema
-- This script creates tables for managing permissions and role-based access control

USE [SWP391]
GO

-- Create Permission table to define system permissions
CREATE TABLE [dbo].[Permission](
    [permission_id] [int] IDENTITY(1,1) NOT NULL,
    [permission_name] [nvarchar](100) NOT NULL,
    [permission_code] [nvarchar](50) NOT NULL,
    [description] [nvarchar](255) NULL,
    [module] [nvarchar](50) NOT NULL, -- e.g., 'USER_MANAGEMENT', 'APPOINTMENTS', 'REPORTS'
    [action] [nvarchar](50) NOT NULL, -- e.g., 'CREATE', 'READ', 'UPDATE', 'DELETE'
    [resource] [nvarchar](100) NULL, -- specific resource if applicable
    [is_active] [bit] NOT NULL DEFAULT 1,
    [created_date] [datetime] NOT NULL DEFAULT GETDATE(),
    [updated_date] [datetime] NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([permission_id] ASC),
    UNIQUE NONCLUSTERED ([permission_code] ASC)
) ON [PRIMARY]
GO

-- Create RolePermission table to map roles to permissions
CREATE TABLE [dbo].[RolePermission](
    [role_permission_id] [int] IDENTITY(1,1) NOT NULL,
    [role_id] [int] NOT NULL,
    [permission_id] [int] NOT NULL,
    [granted] [bit] NOT NULL DEFAULT 1, -- Allow for explicit deny permissions
    [granted_by] [int] NULL, -- User who granted this permission
    [granted_date] [datetime] NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([role_permission_id] ASC),
    UNIQUE NONCLUSTERED ([role_id] ASC, [permission_id] ASC)
) ON [PRIMARY]
GO

-- Create UserPermission table for user-specific permission overrides
CREATE TABLE [dbo].[UserPermission](
    [user_permission_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL,
    [permission_id] [int] NOT NULL,
    [granted] [bit] NOT NULL, -- Can be used to grant or deny specific permissions to users
    [granted_by] [int] NULL, -- User who granted this permission
    [granted_date] [datetime] NOT NULL DEFAULT GETDATE(),
    [expiry_date] [datetime] NULL, -- Optional expiry for temporary permissions
    PRIMARY KEY CLUSTERED ([user_permission_id] ASC),
    UNIQUE NONCLUSTERED ([user_id] ASC, [permission_id] ASC)
) ON [PRIMARY]
GO

-- Create AuditLog table for tracking permission changes
CREATE TABLE [dbo].[AuditLog](
    [audit_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL, -- User who performed the action
    [action_type] [nvarchar](50) NOT NULL, -- 'GRANT_PERMISSION', 'REVOKE_PERMISSION', 'ROLE_CHANGE', etc.
    [target_user_id] [int] NULL, -- User affected by the action
    [target_role_id] [int] NULL, -- Role affected by the action
    [permission_id] [int] NULL, -- Permission affected by the action
    [old_value] [nvarchar](255) NULL, -- Previous value
    [new_value] [nvarchar](255) NULL, -- New value
    [description] [nvarchar](500) NULL,
    [ip_address] [nvarchar](45) NULL,
    [user_agent] [nvarchar](255) NULL,
    [created_date] [datetime] NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([audit_id] ASC)
) ON [PRIMARY]
GO

-- Add foreign key constraints
ALTER TABLE [dbo].[RolePermission] WITH CHECK ADD FOREIGN KEY([role_id])
REFERENCES [dbo].[Role] ([role_id])
GO

ALTER TABLE [dbo].[RolePermission] WITH CHECK ADD FOREIGN KEY([permission_id])
REFERENCES [dbo].[Permission] ([permission_id])
GO

ALTER TABLE [dbo].[RolePermission] WITH CHECK ADD FOREIGN KEY([granted_by])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[UserPermission] WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[UserPermission] WITH CHECK ADD FOREIGN KEY([permission_id])
REFERENCES [dbo].[Permission] ([permission_id])
GO

ALTER TABLE [dbo].[UserPermission] WITH CHECK ADD FOREIGN KEY([granted_by])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[AuditLog] WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[AuditLog] WITH CHECK ADD FOREIGN KEY([target_user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[AuditLog] WITH CHECK ADD FOREIGN KEY([target_role_id])
REFERENCES [dbo].[Role] ([role_id])
GO

ALTER TABLE [dbo].[AuditLog] WITH CHECK ADD FOREIGN KEY([permission_id])
REFERENCES [dbo].[Permission] ([permission_id])
GO

-- Insert default permissions for the system
INSERT INTO [dbo].[Permission] ([permission_name], [permission_code], [description], [module], [action], [resource]) VALUES
-- User Management Permissions
('View Users', 'USER_VIEW', 'View user list and details', 'USER_MANAGEMENT', 'READ', 'users'),
('Create Users', 'USER_CREATE', 'Create new users', 'USER_MANAGEMENT', 'CREATE', 'users'),
('Update Users', 'USER_UPDATE', 'Update user information', 'USER_MANAGEMENT', 'UPDATE', 'users'),
('Delete Users', 'USER_DELETE', 'Delete users from system', 'USER_MANAGEMENT', 'DELETE', 'users'),
('Manage User Roles', 'USER_ROLE_MANAGE', 'Assign and change user roles', 'USER_MANAGEMENT', 'UPDATE', 'user_roles'),
('Reset User Passwords', 'USER_PASSWORD_RESET', 'Reset user passwords', 'USER_MANAGEMENT', 'UPDATE', 'user_passwords'),

-- Role Management Permissions
('View Roles', 'ROLE_VIEW', 'View role list and details', 'ROLE_MANAGEMENT', 'READ', 'roles'),
('Create Roles', 'ROLE_CREATE', 'Create new roles', 'ROLE_MANAGEMENT', 'CREATE', 'roles'),
('Update Roles', 'ROLE_UPDATE', 'Update role information', 'ROLE_MANAGEMENT', 'UPDATE', 'roles'),
('Delete Roles', 'ROLE_DELETE', 'Delete roles from system', 'ROLE_MANAGEMENT', 'DELETE', 'roles'),
('Manage Role Permissions', 'ROLE_PERMISSION_MANAGE', 'Assign permissions to roles', 'ROLE_MANAGEMENT', 'UPDATE', 'role_permissions'),

-- Permission Management Permissions
('View Permissions', 'PERMISSION_VIEW', 'View permission list and details', 'PERMISSION_MANAGEMENT', 'READ', 'permissions'),
('Create Permissions', 'PERMISSION_CREATE', 'Create new permissions', 'PERMISSION_MANAGEMENT', 'CREATE', 'permissions'),
('Update Permissions', 'PERMISSION_UPDATE', 'Update permission information', 'PERMISSION_MANAGEMENT', 'UPDATE', 'permissions'),
('Delete Permissions', 'PERMISSION_DELETE', 'Delete permissions from system', 'PERMISSION_MANAGEMENT', 'DELETE', 'permissions'),

-- Appointment Management Permissions
('View All Appointments', 'APPOINTMENT_VIEW_ALL', 'View all appointments in system', 'APPOINTMENTS', 'READ', 'all_appointments'),
('View Own Appointments', 'APPOINTMENT_VIEW_OWN', 'View own appointments only', 'APPOINTMENTS', 'READ', 'own_appointments'),
('Create Appointments', 'APPOINTMENT_CREATE', 'Create new appointments', 'APPOINTMENTS', 'CREATE', 'appointments'),
('Update Appointments', 'APPOINTMENT_UPDATE', 'Update appointment information', 'APPOINTMENTS', 'UPDATE', 'appointments'),
('Cancel Appointments', 'APPOINTMENT_CANCEL', 'Cancel appointments', 'APPOINTMENTS', 'DELETE', 'appointments'),

-- Patient Management Permissions
('View All Patients', 'PATIENT_VIEW_ALL', 'View all patient records', 'PATIENTS', 'READ', 'all_patients'),
('View Assigned Patients', 'PATIENT_VIEW_ASSIGNED', 'View assigned patient records only', 'PATIENTS', 'READ', 'assigned_patients'),
('Create Patient Records', 'PATIENT_CREATE', 'Create new patient records', 'PATIENTS', 'CREATE', 'patients'),
('Update Patient Records', 'PATIENT_UPDATE', 'Update patient information', 'PATIENTS', 'UPDATE', 'patients'),
('Delete Patient Records', 'PATIENT_DELETE', 'Delete patient records', 'PATIENTS', 'DELETE', 'patients'),

-- Medical Records Permissions
('View Medical Records', 'MEDICAL_RECORD_VIEW', 'View medical records', 'MEDICAL_RECORDS', 'READ', 'medical_records'),
('Create Medical Records', 'MEDICAL_RECORD_CREATE', 'Create medical records', 'MEDICAL_RECORDS', 'CREATE', 'medical_records'),
('Update Medical Records', 'MEDICAL_RECORD_UPDATE', 'Update medical records', 'MEDICAL_RECORDS', 'UPDATE', 'medical_records'),
('Delete Medical Records', 'MEDICAL_RECORD_DELETE', 'Delete medical records', 'MEDICAL_RECORDS', 'DELETE', 'medical_records'),

-- Reports and Analytics Permissions
('View System Reports', 'REPORT_VIEW_SYSTEM', 'View system-wide reports', 'REPORTS', 'READ', 'system_reports'),
('View Financial Reports', 'REPORT_VIEW_FINANCIAL', 'View financial reports', 'REPORTS', 'READ', 'financial_reports'),
('Generate Reports', 'REPORT_GENERATE', 'Generate custom reports', 'REPORTS', 'CREATE', 'reports'),
('Export Reports', 'REPORT_EXPORT', 'Export reports to various formats', 'REPORTS', 'READ', 'report_exports'),

-- System Administration Permissions
('System Configuration', 'SYSTEM_CONFIG', 'Modify system configuration', 'SYSTEM', 'UPDATE', 'system_config'),
('View Audit Logs', 'AUDIT_LOG_VIEW', 'View system audit logs', 'SYSTEM', 'READ', 'audit_logs'),
('Backup System', 'SYSTEM_BACKUP', 'Perform system backup', 'SYSTEM', 'CREATE', 'system_backup'),
('Restore System', 'SYSTEM_RESTORE', 'Restore system from backup', 'SYSTEM', 'UPDATE', 'system_restore'),

-- Queue Management Permissions
('Manage Patient Queue', 'QUEUE_MANAGE', 'Manage patient queue', 'QUEUE', 'UPDATE', 'patient_queue'),
('View Queue Status', 'QUEUE_VIEW', 'View queue status', 'QUEUE', 'READ', 'patient_queue');

-- Insert default role permissions (assuming role_id: 1=Admin, 2=Doctor, 3=Receptionist, 4=Patient)
-- Admin gets all permissions
INSERT INTO [dbo].[RolePermission] ([role_id], [permission_id], [granted])
SELECT 1, [permission_id], 1 FROM [dbo].[Permission] WHERE [is_active] = 1;

-- Doctor permissions
INSERT INTO [dbo].[RolePermission] ([role_id], [permission_id], [granted])
SELECT 2, [permission_id], 1 FROM [dbo].[Permission] 
WHERE [permission_code] IN (
    'APPOINTMENT_VIEW_ALL', 'APPOINTMENT_UPDATE',
    'PATIENT_VIEW_ASSIGNED', 'PATIENT_UPDATE',
    'MEDICAL_RECORD_VIEW', 'MEDICAL_RECORD_CREATE', 'MEDICAL_RECORD_UPDATE',
    'QUEUE_VIEW'
);

-- Receptionist permissions
INSERT INTO [dbo].[RolePermission] ([role_id], [permission_id], [granted])
SELECT 3, [permission_id], 1 FROM [dbo].[Permission] 
WHERE [permission_code] IN (
    'APPOINTMENT_VIEW_ALL', 'APPOINTMENT_CREATE', 'APPOINTMENT_UPDATE', 'APPOINTMENT_CANCEL',
    'PATIENT_VIEW_ALL', 'PATIENT_CREATE', 'PATIENT_UPDATE',
    'QUEUE_MANAGE', 'QUEUE_VIEW'
);

-- Patient permissions
INSERT INTO [dbo].[RolePermission] ([role_id], [permission_id], [granted])
SELECT 4, [permission_id], 1 FROM [dbo].[Permission] 
WHERE [permission_code] IN (
    'APPOINTMENT_VIEW_OWN', 'APPOINTMENT_CREATE'
);

GO

-- Create indexes for better performance
CREATE NONCLUSTERED INDEX [IX_Permission_Module] ON [dbo].[Permission] ([module]) INCLUDE ([permission_code], [is_active])
GO

CREATE NONCLUSTERED INDEX [IX_RolePermission_Role] ON [dbo].[RolePermission] ([role_id]) INCLUDE ([permission_id], [granted])
GO

CREATE NONCLUSTERED INDEX [IX_UserPermission_User] ON [dbo].[UserPermission] ([user_id]) INCLUDE ([permission_id], [granted])
GO

CREATE NONCLUSTERED INDEX [IX_AuditLog_Date] ON [dbo].[AuditLog] ([created_date] DESC)
GO

CREATE NONCLUSTERED INDEX [IX_AuditLog_User] ON [dbo].[AuditLog] ([user_id]) INCLUDE ([action_type], [created_date])
GO

PRINT 'Authorization Management Database Schema created successfully!'