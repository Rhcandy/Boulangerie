package model;

import java.sql.Timestamp;

import org.entityframework.tools.Primary;



public class Achats {
    @Primary(auto = true)
    private int Id_Achats;
    private double qttInitiale;
    private double qttReste;
    private double prixUnitaire;
    private Timestamp dateExpiration;
    private int idIngredients;
    public int getId_Achats() {
        return Id_Achats;
    }
    public void setId_Achats(int id_Achats) {
        Id_Achats = id_Achats;
    }
    public double getQttInitiale() {
        return qttInitiale;
    }
    public void setQttInitiale(double qttInitiale) {
        this.qttInitiale = qttInitiale;
    }
    public double getQttReste() {
        return qttReste;
    }
    public void setQttReste(double qttReste) {
        this.qttReste = qttReste;
    }
    public double getPrixUnitaire() {
        return prixUnitaire;
    }
    public void setPrixUnitaire(double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }
    public Timestamp getDateExpiration() {
        return dateExpiration;
    }
    public void setDateExpiration(Timestamp dateExpiration) {
        this.dateExpiration = dateExpiration;
    }
    public int getIdIngredients() {
        return idIngredients;
    }
    public void setIdIngredients(int idIngredients) {
        this.idIngredients = idIngredients;
    }

}
