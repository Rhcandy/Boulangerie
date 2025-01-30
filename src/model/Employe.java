package model;

import javax.persistence.Table;


import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.Primary;


@Table(name = "Employe")
public class Employe {
    @Primary(auto = true)
    private int Id_Employe;

    @FK(Roles.class)
    @Col(name = "Id_Role")
    private int Id_Role;

    private String Nom;
    
    @FK(Genre.class)
    @Col(name="Id_Genre")
    private Genre Id_Genre;

    
    public int getId_Employe() {
        return Id_Employe;
    }
    public void setId_Employe(int id_Employe) {
        Id_Employe = id_Employe;
    }

    public Genre getId_Genre(){
        return Id_Genre;
    }

    public void setId_Genre(Genre g){
        this.Id_Genre = g;
    }

    

    public int getId_Role() {
        return Id_Role;
    }
    public void setId_Role(int id_Role) {
        Id_Role = id_Role;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        Nom = nom;
    }

}
