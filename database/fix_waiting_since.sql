-- Script để sửa lại dữ liệu waiting_since
-- Chỉ giữ waiting_since cho các appointment đã từng ở trạng thái Testing
-- (có medical report với test_request = 1)

-- Reset waiting_since = NULL cho các appointment Waiting mà CHƯA BAO GIỜ yêu cầu xét nghiệm
-- (check-in lần đầu, không phải quay lại từ Testing)
UPDATE Appointment
SET waiting_since = NULL
WHERE status = 'Waiting'
  AND appointment_id NOT IN (
      SELECT DISTINCT a.appointment_id
      FROM Appointment a
      INNER JOIN MedicalReport mr ON a.appointment_id = mr.appointment_id
      WHERE mr.test_request = 1
  );

-- Kiểm tra kết quả
SELECT 
    appointment_id,
    status,
    waiting_since,
    date_time,
    CASE 
        WHEN waiting_since IS NOT NULL THEN 'Quay lại từ Testing'
        ELSE 'Check-in lần đầu'
    END AS note
FROM Appointment
WHERE status = 'Waiting'
ORDER BY 
    CASE WHEN waiting_since IS NOT NULL THEN 0 ELSE 1 END,
    waiting_since DESC,
    appointment_id ASC;

