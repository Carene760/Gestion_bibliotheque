package org.exemple.model;

import jakarta.persistence.*;

@Entity
@Table(name = "type_abonnement")
public class TypeAbonnement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, unique = true)
    private String libelle;

    @Column(nullable = false)
    private double tarif;

    @Column(name = "quota_livre", nullable = false)
    private int quotaLivre;

    @Column(name = "duree_pret_jour", nullable = false)
    private int dureePretJour;

    @Column(name = "quota_reservation", nullable = false)
    private int quotaReservation;

    @Column(name = "quota_prolongement", nullable = false)
    private int quotaProlongement;

    @Column(name = "nb_jour_prolongement",nullable = false)
    private int nbJourProlongement;

    // Getters et setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
    public double getTarif() { return tarif; }
    public void setTarif(double tarif) { this.tarif = tarif; }
    public int getQuotaLivre() { return quotaLivre; }
    public void setQuotaLivre(int quotaLivre) { this.quotaLivre = quotaLivre; }
    public int getDureePretJour() { return dureePretJour; }
    public void setDureePretJour(int dureePretJour) { this.dureePretJour = dureePretJour; }
    public int getQuotaReservation() { return quotaReservation; }
    public void setQuotaReservation(int quotaReservation) { this.quotaReservation = quotaReservation; }
    public int getQuotaProlongement() { return quotaProlongement; }
    public void setQuotaProlongement(int quotaProlongement) { this.quotaProlongement = quotaProlongement; }
    public int getNbJourProlongement() { return nbJourProlongement; }
    public void setNbJourProlongement(int nbJourProlongement) { this.nbJourProlongement = nbJourProlongement;}
}
