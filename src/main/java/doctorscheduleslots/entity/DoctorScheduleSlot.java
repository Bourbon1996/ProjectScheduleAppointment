package doctorscheduleslots.entity;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import appointments.entity.Appointment;
import doctors.entity.Doctor; // Import Entity Doctor vào
import enums.SlotStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "doctor_schedule_slots") // Khớp chính xác với tên bảng SQL
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DoctorScheduleSlot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @Column(name = "work_date")
    private LocalDate workDate;

    @Column(name = "start_time")
    private LocalTime startTime;

    @Column(name = "end_time")
    private LocalTime endTime;

    @Column(name = "max_patients")
    private Integer maxPatients;

    @Column(name = "booked_count")
    private Integer bookedCount;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SlotStatus status;

    @OneToMany(mappedBy = "slot")
    private List<Appointment> appointments;
}