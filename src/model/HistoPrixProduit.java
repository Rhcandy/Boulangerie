package model;

import java.sql.Date;

import javax.persistence.Table;

import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.Primary;

@Table(name = "HistoPrixProduit")
public class HistoPrixProduit {
    @Primary(auto = true)
    private int Id_H;

    @FK(Produit.class)
    @Col(name = "Id_prod")
    private Produit Id_prod;

    private Date Date_insert;

    private double Prix;

    public int getId_H() {
        return Id_H;
    }

    public void setId_H(int id_H) {
        Id_H = id_H;
    }

    public Produit getId_prod() {
        return Id_prod;
    }

    public void setId_prod(Produit id_prod) {
        Id_prod = id_prod;
    }

    public Date getDate_insert() {
        return Date_insert;
    }

    public void setDate_insert(Date date_insert) {
        Date_insert = date_insert;
    }

    public double getPrix() {
        return Prix;
    }

    public void setPrix(double prix) {
        Prix = prix;
    }

   

}
