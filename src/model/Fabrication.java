package model;
import java.sql.Timestamp;

import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Fabrication_")
public class Fabrication {
    @Primary(auto = true)
    @Col(name = "Id_Fabrication_")
    private int idFabrication;

    @Col(name = "qtt_initiale")
    private int qttInitiale;

    @Col(name = "qtt_reste")
    private int qttReste;

    @Col(name = "Dt_Fabrique")
    private Timestamp dtFabrique;

    @Col(name = "Dt_Expiration")
    private Timestamp dtExpiration;
    @Col(name = "Cout_fabrication_unitaire")
    private double coutFabricationUnitaire;
    @FK(Produit.class)
    @Col(name = "Id_Produit")
    private Produit Produit;

    public int getIdFabrication() {
        return idFabrication;
    }
    public void setIdFabrication(int idFabrication) {
        this.idFabrication = idFabrication;
    }
    public int getQttInitiale() {
        return qttInitiale;
    }
    public void setQttInitiale(int qttInitiale) {
        this.qttInitiale = qttInitiale;
    }
    public int getQttReste() {
        return qttReste;
    }
    public void setQttReste(int qttReste) {
        this.qttReste = qttReste;
    }
    public Timestamp getDtFabrique() {
        return dtFabrique;
    }
    public void setDtFabrique(Timestamp dtFabrique) {
        this.dtFabrique = dtFabrique;
    }
    public Timestamp getDtExpiration() {
        return dtExpiration;
    }
    public void setDtExpiration(Timestamp dtExpiration) {
        this.dtExpiration = dtExpiration;
    }
    public double getCoutFabricationUnitaire() {
        return coutFabricationUnitaire;
    }
    public void setCoutFabricationUnitaire(double coutFabricationUnitaire) {
        this.coutFabricationUnitaire = coutFabricationUnitaire;
    }
    public Produit getProduit() {
        return Produit;
    }
    public void setProduit(Produit Produit) {
        this.Produit = Produit;
    }

   

}
