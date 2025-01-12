package model;

import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Details_Ventes")
public class Details_Ventes {
    @Primary(auto = true)
    @Col(name = "Id_Details_Ventes")
    private int idDetailsVentes;
    @FK(Vente.class)
    @Col(name = "Id_Vente")
    private int idVente;
  
    private double qtt;

    @FK(Produit.class)
    @Col(name = "Id_Produit")
    private Produit idProduit;

    public int getIdVente() {
        return idVente;
    }

    public void setIdVente(int idVente) {
        this.idVente = idVente;
    }

    public int getIdDetailsVentes() {
        return idDetailsVentes;
    }

    public void setIdDetailsVentes(int idDetailsVentes) {
        this.idDetailsVentes = idDetailsVentes;
    }

    public double getQtt() {
        return qtt;
    }

    public void setQtt(double qtt) {
        this.qtt = qtt;
    }

    public Produit getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(Produit idProduit) {
        this.idProduit = idProduit;
    }
}
