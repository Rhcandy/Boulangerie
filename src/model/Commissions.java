package model;

import java.sql.Timestamp;

import org.entityframework.tools.Col;
import org.entityframework.tools.FK;

public class Commissions {

    @FK(Employe.class)
    @Col(name="Id_Employe")
    private Employe Id_Employe;
    private double total_commission;
    private int Nombre_Total_Ventes;
    
    public Employe getId_Employe() {
        return Id_Employe;
    }
    public void setId_Employe(Employe id_Employe) {
        Id_Employe = id_Employe;
    }
    public double getTotal() {
        return total_commission;
    }
    public void setTotal(double total) {
        this.total_commission = total;
    }
    public int getNb_vente() {
        return Nombre_Total_Ventes;
    }
    public void setNb_vente(int nb_vente) {
        this.Nombre_Total_Ventes = nb_vente;
    }


    
}
