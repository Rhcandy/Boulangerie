package model;

import java.time.LocalDateTime;

import org.entityframework.tools.Col;
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Vente")
public class Vente {
    @Primary(auto = true)
    @Col(name = "id_vente")
    private int idVente;

    @Col(name = "total")
    private double total;

    @Col(name = "date_vente")
    private LocalDateTime dateVente;

}
