-- Add room_number column to PatientQueue table
-- This tracks which consultation room the patient is assigned to

ALTER TABLE PatientQueue
ADD room_number VARCHAR(20) NULL;

-- Add index for faster room number queries
CREATE INDEX idx_room_number ON PatientQueue(room_number);