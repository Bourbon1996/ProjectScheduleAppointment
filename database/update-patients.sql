use scheduleappointment

ALTER TABLE patients 
ADD full_name NVARCHAR(100) NOT NULL DEFAULT N'Chưa cập nhật',
    phone VARCHAR(20) NULL;

insert into users (full_name, email, phone, password_hash, role, status) 
values(N'baduc','duc@gmail.com','0348853878', '123', 'patient', 'active' );

UPDATE users
SET role = 'PATIENT',
    status = 'ACTIVE'
WHERE phone = '0348853878';