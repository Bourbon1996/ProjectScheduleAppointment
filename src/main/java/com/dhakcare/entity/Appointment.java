package com.dhakcare.entity;

import java.time.LocalDateTime;

import com.dhakcare.enums.AppointmentStatus;
import com.dhakcare.enums.PaymentStatus;

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
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "appointments")
@Getter
@Setter
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
    
    
    @Column(name = "payment_status")
    @Enumerated(EnumType.STRING)
    private PaymentStatus paymentStatus;
}