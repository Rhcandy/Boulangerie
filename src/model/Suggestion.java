package model;

import java.sql.Timestamp;

import javax.persistence.Table;

import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.Primary;


@Table(name="Suggestion")
public class Suggestion {

    @Primary(auto = true)
    private int Id_Suggestion;

    @FK(Produit.class)
    @Col(name = "Id_Produit")
    private Produit Id_Produit;

    private Timestamp Date_deb ;
    private Timestamp Date_fin ;
    private String Descri;

    public int getId_Suggestion() {
        return Id_Suggestion;
    }
    public void setId_Suggestion(int id_Suggestion) {
        Id_Suggestion = id_Suggestion;
    }
    public Produit getId_Produit() {
        return Id_Produit;
    }
    public void setId_Produit(Produit id_Produit) {
        Id_Produit = id_Produit;
    }
    public Timestamp getDate_deb() {
        return Date_deb;
    }
    public void setDate_deb(Timestamp date_deb) {
        Date_deb = date_deb;
    }
    public Timestamp getDate_fin() {
        return Date_fin;
    }
    public void setDate_fin(Timestamp date_fin) {
        Date_fin = date_fin;
    }
    public String getDescri() {
        return Descri;
    }
    public void setDescri(String descri) {
        Descri = descri;
    }
    
}
