package com.dhakcare.entity;

import java.math.BigDecimal;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "departments")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String description;

    private String status;

    @Column(name = "image_url")
    private String imageUrl;
    
    @Builder.Default
    @Column(name = "base_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal basePrice = new BigDecimal("150000.00");
    
    @OneToMany(mappedBy = "department")
    private List<Doctor> doctors;

    @OneToMany(mappedBy = "department")
    private List<Appointment> appointments;
    
    @ManyToOne
    @JoinColumn(name = "parent_id") 
    private Department parent;

    @OneToMany(mappedBy = "parent") 
    private List<Department> subDepartments;

}