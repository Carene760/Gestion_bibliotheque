package org.exemple.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "adherent")
public class Adherent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String nom;
    private String prenom;
    private String email;

    @ManyToOne
    @JoinColumn(name = "id_type_abonnement", nullable = false)
    private TypeAbonnement typeAbonnement;

    private String adresse;
    private String etat;

    @Column(name = "date_naissance")
    private LocalDateTime dateNaissance;

    // Getters
    public int getId() { return id; }
    public String getNom() { return nom; }
    public String getPrenom() { return prenom; }
    public String getEmail() { return email; }
    public TypeAbonnement getTypeAbonnement() { return typeAbonnement; }
    public String getAdresse() { return adresse; }
    public String getEtat() { return etat; }
    public LocalDateTime getDateNaissance() { return dateNaissance; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setNom(String nom) { this.nom = nom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public void setEmail(String email) { this.email = email; }
    public void setTypeAbonnement(TypeAbonnement typeAbonnement) { this.typeAbonnement = typeAbonnement; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
    public void setEtat(String etat) { this.etat = etat; }
    public void setDateNaissance(LocalDateTime dateNaissance) { this.dateNaissance = dateNaissance; }
}
