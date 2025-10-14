-- Add default doctor to the database
-- First, insert a user with doctor role (role_id = 2 for Doctor)
INSERT INTO [User] (username, password, email, phone, role_id, status) 
VALUES ('default_doctor', 'password123', 'doctor@hospital.com', '0123456789', 2, 1);

-- Get the user_id of the inserted user and create a doctor record
-- Note: This assumes the user_id will be 1, but in practice you should use the actual generated ID
INSERT INTO Doctor (user_id, specialty) 
VALUES (1, 'General Medicine');