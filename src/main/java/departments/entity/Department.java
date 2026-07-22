package departments.entity;

import java.util.List;

import appointments.entity.Appointment;
import doctors.entity.Doctor;
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
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.util.Objects;

@Entity
@Table(name = "departments")
@Data
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
    
    @OneToMany(mappedBy = "department")
    private List<Doctor> doctors;

    @OneToMany(mappedBy = "department")
    private List<Appointment> appointments;
    
    @ManyToOne
    @JoinColumn(name = "parent_id") 
    private Department parent;

    @OneToMany(mappedBy = "parent") 
    private List<Department> subDepartments;
    

    public BigDecimal getMinFee() {
        if (this.doctors == null || this.doctors.isEmpty()) {
            return BigDecimal.ZERO;
        }
        
        return this.doctors.stream()
                .map(Doctor::getExaminationFee)
                .filter(Objects::nonNull)
                .min(BigDecimal::compareTo)
                .orElse(BigDecimal.ZERO);
        
    }
}