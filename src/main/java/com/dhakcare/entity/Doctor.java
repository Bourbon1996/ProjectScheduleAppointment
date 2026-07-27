package com.dhakcare.entity;

import java.math.BigDecimal;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "doctors")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Doctor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;

    private String title;

    @Column(name = "avt_url")
    private String avtUrl;
    
    @Column(name = "examination_fee", nullable = false, precision = 18, scale = 2)
    private BigDecimal examinationFee = new BigDecimal("150000.00");

    @Column(name = "experience_years")
    private Integer experienceYears;

    private String description;

    @OneToMany(mappedBy = "doctor")
    private List<DoctorScheduleSlot> slots;

    @OneToMany(mappedBy = "doctor")
    private List<Appointment> appointments;
}