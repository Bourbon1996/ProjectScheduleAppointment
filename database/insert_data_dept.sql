use scheduleappointment
go

UPDATE departments
SET base_price = 150000
WHERE base_price IS NULL;