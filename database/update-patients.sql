use scheduleappointment

ALTER TABLE patients 
ADD full_name NVARCHAR(100) NOT NULL DEFAULT N'Chưa cập nhật',
    phone VARCHAR(20) NULL;