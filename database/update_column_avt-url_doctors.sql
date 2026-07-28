USE [scheduleappointment];
GO

-- Kiểm tra xem cột avt_url đã tồn tại trong bảng doctors chưa
IF NOT EXISTS (
    SELECT * 
    FROM sys.columns 
    WHERE Name = N'avt_url' 
      AND Object_ID = Object_ID(N'dbo.doctors')
)
BEGIN
    -- Nếu chưa có thì tiến hành thêm cột mới (cho phép NULL)
    ALTER TABLE [dbo].[doctors] 
    ADD [avt_url] VARCHAR(100) NULL;
    
    PRINT N'>>> Đã thêm cột avt_url vào bảng doctors thành công!';
END
ELSE
BEGIN
    -- Nếu đã có rồi thì thông báo chứ không báo lỗi
    PRINT N'>>> Cột avt_url đã tồn tại trong bảng doctors từ trước rồi!';
END
GO