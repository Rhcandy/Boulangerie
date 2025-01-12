package model;

import java.sql.Timestamp;
import java.util.List;

import org.entityframework.tools.Col;
import org.entityframework.tools.OneToMany;
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Vente")
public class Vente {
    @Primary(auto = true)
    private int Id_Vente;
    private double Total;
    @Col(name = "Date_vente")
    private Timestamp dateVente;

    @OneToMany(Details_Ventes.class)
    private List<Details_Ventes> composant;

    public int getIdVente() {
        return Id_Vente;
    }

    public void setIdVente(int idVente) {
        this.Id_Vente = idVente;
    }

    public double getTotal() {
        return Total;
    }

    public void setTotal(double total) {
        this.Total = total;
    }

    public Timestamp getDateVente() {
        return dateVente;
    }

    public void setDateVente(Timestamp dateVente) {
        this.dateVente = dateVente;
    }

    public List<Details_Ventes> getComposant() {
        return composant;
    }

    public void setComposant(List<Details_Ventes> composant) {
        this.composant = composant;
    }

    



}
