use scheduleappointment
go

INSERT INTO [dbo].[doctor_schedule_slots] 
    ([doctor_id], [work_date], [start_time], [end_time], [max_patients], [booked_count], [status])
SELECT 
    d.id AS doctor_id,
    CAST('2026-08-04' AS DATE) AS work_date,
    slots.start_time,
    slots.end_time,
    10 AS max_patients,
    0 AS booked_count,
    'AVAILABLE' AS status
FROM 
    [dbo].[doctors] d
CROSS JOIN 
    (VALUES 
        (CAST('07:00:00' AS TIME), CAST('08:00:00' AS TIME)),
        (CAST('08:00:00' AS TIME), CAST('09:00:00' AS TIME)),
        (CAST('09:00:00' AS TIME), CAST('10:00:00' AS TIME)),
        (CAST('10:00:00' AS TIME), CAST('11:00:00' AS TIME)),
        (CAST('11:00:00' AS TIME), CAST('12:00:00' AS TIME)),
        (CAST('13:00:00' AS TIME), CAST('14:00:00' AS TIME)),
        (CAST('14:00:00' AS TIME), CAST('15:00:00' AS TIME)),
        (CAST('15:00:00' AS TIME), CAST('16:00:00' AS TIME)),
        (CAST('16:00:00' AS TIME), CAST('17:00:00' AS TIME))
    ) AS slots(start_time, end_time);
GO
