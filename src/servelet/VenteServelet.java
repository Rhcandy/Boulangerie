package servelet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;

import dao.Connector;
import model.Details_Ventes;
import model.Employe;
import model.Produit;
import model.Vente;
import model.Clients;

@WebServlet( name = "VenteServelet" ,value = "/VenteServlet")
public class VenteServelet extends HttpServlet  {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try( GenericEntity service=new GenericEntity(Connector.getConnection());) {
             List<Produit> Produits =service.findAll(Produit.class);
             List<Produit> ProdMisy=new ArrayList<Produit>();
             for (Produit produit : Produits) {
                if (produit.getstock() > 0) {
                    ProdMisy.add(produit);
                }
             }
             List<Employe> Employe=service.findWhere(Employe.class,"Id_Role=1");
             List<Clients> kils=service.findAll(Clients.class);
             request.setAttribute("Produits", ProdMisy);
             request.setAttribute("Vendeur", Employe);
             request.setAttribute("Clients",kils);
        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/vente.jsp");
        dispatcher.forward(request, response);
        
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try (GenericEntity service=new GenericEntity(Connector.getConnection())){ 
             
            Vente vente = new Vente();
            vente.setTotal(Double.parseDouble(request.getParameter("total")));
            vente.setDateVente(new java.sql.Timestamp(System.currentTimeMillis()));
            Employe emp= service.findById(Integer.parseInt(request.getParameter("Vendeur")), Employe.class);
            Clients kil=service.findById(Integer.parseInt(request.getParameter("client")),Clients.class);
            vente.setId_Employe(emp);
            vente.setClient(kil);
            String[] produitId = request.getParameterValues("ProduitsId[]");
            String[] produitcount = request.getParameterValues("ProduitsQtt[]");
           /*  String[] produitsPrix = request.getParameterValues("ProduitsPrix[]"); */

            List<Details_Ventes> details = new  ArrayList<Details_Ventes>();
                for (int i = 0; i < produitId.length; i++) {
                    Produit prod= service.findById(Integer.parseInt(produitId[i]), Produit.class);
                     Details_Ventes stl= new  Details_Ventes();
                     stl.setIdProduit(prod);
                     stl.setQtt(Double.parseDouble(produitcount[i]));
                     details.add(stl);
                }
            vente.setComposant(details);

            service.beginTransaction();
            service.deepSave(vente);
            service.commit();service.commit();
                    
            response.sendRedirect(request.getContextPath()+"/home"); 
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
