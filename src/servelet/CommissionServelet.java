package servelet;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;

import dao.Connector;
import model.Commissions;
import model.Genre;

@WebServlet( name = "CommissionServelet" ,value = "/CommissionServelet")
public class CommissionServelet extends HttpServlet  {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try( GenericEntity service=new GenericEntity(Connector.getConnection());) {
             List<Commissions> Com = service.executeToList(Commissions.class, "select * from calculer_commission (?)",5);
             List<Genre> genre = service.findAll(Genre.class); 
            
             request.setAttribute("Commission", Com);
             request.setAttribute("Genre", genre);
        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/employe.jsp");
        dispatcher.forward(request, response);
        
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try (GenericEntity service = new GenericEntity(Connector.getConnection())) {
    
            // Récupération et conversion des paramètres de la requête
            String dateDebParam = request.getParameter("date_Deb");
            String dateFinParam = request.getParameter("date_Fin");
            int sexe = Integer.parseInt(request.getParameter("Genre"));
            
            // Conversion des paramètres en Timestamp
            Timestamp dateDeb = null;
            Timestamp dateFin = null;
    
            try {
                if (dateDebParam != null && !dateDebParam.trim().isEmpty()) {
                    dateDeb = Timestamp.valueOf(dateDebParam + " 00:00:00"); // Ajout de l'heure pour éviter les erreurs
                }
                if (dateFinParam != null && !dateFinParam.trim().isEmpty()) {
                    dateFin = Timestamp.valueOf(dateFinParam + " 23:59:59"); // Fin de la journée
                }
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            }
    
            // Appel de la fonction stockée avec les paramètres
            List<Commissions> com = service.executeToList(
                Commissions.class, 
                "SELECT * FROM calculer_commission(?, ?, ?,?)", 
                5, dateDeb, dateFin,sexe
            );
            List<Genre> genre = service.findAll(Genre.class); 
            request.setAttribute("Genre", genre);
            // Ajout des données comme attributs pour la JSP
            request.setAttribute("Commission", com);
    
            // Redirection vers la page employé
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/employe.jsp");
            dispatcher.forward(request, response);
    
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
}
