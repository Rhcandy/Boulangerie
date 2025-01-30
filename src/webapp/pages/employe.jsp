<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.*"%>
<%
 
  List<Genre> Emps = (List<Genre>) request.getAttribute("Genre");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Commission des Employés</title>
    <link href="<%= request.getContextPath() %>/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <header id="header" class="header d-flex align-items-center sticky-top">
        <div class="container d-flex align-items-center justify-content-between">
        <a href="#" class="logo d-flex align-items-center">
            <h1>Boulangerie</h1>
        </a>
        <nav class="navbar">
            <ul class="nav">
            <li><a class="nav-link active" href="<%= request.getContextPath() %>/home">Home</a></li>
            </ul>
        </nav>
        </div>
    </header>

    <main class="container mt-5">
    <div class="container">
        <h1 class="text-center">Commission des Employés</h1>

        
        <!-- Formulaire de filtre -->
        <form class="row g-3 mt-4" action="CommissionServelet" method="post">
            <div class="col-md-5">
                <label for="date_Deb" class="form-label">Date de début</label>
                <input type="date" class="form-control" id="date_Deb" name="date_Deb">
            </div>
            <div class="col-md-5">
                <label for="date_Fin" class="form-label">Date de fin</label>
                <input type="date" class="form-control" id="date_Fin" name="date_Fin">
            </div>
            <div>
            <select name="Genre" id="">
              <% for (Genre emp : Emps) { %>
                <option value="<%=emp.getId_Genre()%>">
                    <%=emp.getNom()%>
                </option>
            <% } %>
            </select>
          </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Filtrer</button>
            </div>
        </form>

        <!-- Résultats -->
        <div class="mt-5">
            <h2>Résultats</h2>
            <%
                // Récupération de la liste des commissions depuis la requête
                List<Commissions> commissions = (List<Commissions>) request.getAttribute("Commission");
                Double total=0.0;
                if (commissions != null && !commissions.isEmpty()) {
            %>
                <table class="table table-bordered table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>Employes</th>
                            <th>Total Commission (Ar)</th>
                            <th>Nombre Total de Ventes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Commissions commission : commissions) { 
                            total+=commission.getTotal(); %>
                            <tr>
                                <td><%= commission.getId_Employe().getNom() %></td>
                                <td><%= commission.getTotal() %></td>
                                <td><%= commission.getNb_vente() %></td>
                            </tr>
                        <% } %>
                    </tbody>

                </table>
                <h1><%=total %></h1>
            <%
                } else {
            %>
                <p class="text-muted">Aucune commission trouvee pour les critères spécifiés.</p>
            <%
                }
            %>
        </div>
    </div>
    </main>

    <script src="<%= request.getContextPath() %>/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
