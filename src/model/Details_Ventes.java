package model;

import org.entityframework.tools.Col;
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Details_Ventes")
public class Details_Ventes {
    @Primary(auto = true)
    @Col(name = "id_vente")
    private int idVente;

    @Col(name = "id_details_ventes")
    private int idDetailsVentes;

    @Col(name = "qtt")
    private double qtt;

    @Col(name = "id_produit")
    private int idProduit;
}
