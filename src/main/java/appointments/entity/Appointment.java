package appointments.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import departments.entity.Department;
import doctors.entity.Doctor;
import doctorscheduleslots.entity.DoctorScheduleSlot;
import enums.AppointmentStatus;
import enums.Relationship;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import patients.entity.Patient;
import payments.entity.Payment;
import users.entity.User;

@Entity
@Table(name = "appointments")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;

    @ManyToOne
    @JoinColumn(name = "slot_id")
    private DoctorScheduleSlot slot;

    @Column(name = "appointment_date")
    private LocalDate appointmentDate;

    @Column(name = "appointment_time")
    private LocalTime appointmentTime;

    private String reason;

    @Enumerated(EnumType.STRING)
    private AppointmentStatus status;

    @Column(name = "queue_number")
    private Integer queueNumber;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @OneToOne(mappedBy = "appointment")
    private Payment payment;
    
    @ManyToOne
    @JoinColumn(name = "booked_by")
    private User bookedBy;

    @Enumerated(EnumType.STRING)
    private Relationship relationship;
}