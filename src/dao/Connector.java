package dao;

import java.sql.Connection;


import org.entityframework.dev.Driver;
import java.sql.SQLException;

public class Connector {
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        return Driver.getPGConnection("postgres", "ando", "boulangerie");
    }

}
