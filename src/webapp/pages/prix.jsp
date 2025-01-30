<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.*" %>
<%
    // Récupération des données envoyées par le servlet
    List<Categories> categories = (List<Categories>) request.getAttribute("categories");
    List<HistoPrixProduit> produitPrixList = (List<HistoPrixProduit>) request.getAttribute("Produit_prix");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des Prix</title>
    <link href="<%= request.getContextPath() %>/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script src="<%= request.getContextPath() %>/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/assets/vendor/jquery/jquery.min.js"></script>
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

<div class="container my-4">
    <h1 class="text-center mb-4">Historique des Prix</h1>

    <!-- Section de filtrage -->
    <form id="filterForm" class="mb-4">
        <div class="row">
            <!-- Filtre par catégorie -->
            <div class="col-md-3">
                <label for="categoryFilter" class="form-label">Catégorie</label>
                <select id="categoryFilter" class="form-select">
                    <option value="">Toutes les catégories</option>
                    <% for (Categories category : categories) { %>
                        <option value="<%= category.getIdCategorie() %>"><%= category.getNom() %></option>
                    <% } %>
                </select>
            </div>

            <!-- Filtre par date -->
            <div class="col-md-3">
                <label for="dateFilter" class="form-label">Date</label>
                <input type="date" id="dateFilter" class="form-control">
            </div>

            <!-- Filtre par mois -->
            <div class="col-md-3">
                <label for="monthFilter" class="form-label">Mois</label>
                <select id="monthFilter" class="form-select">
                    <option value="">Tous les mois</option>
                    <% for (int i = 1; i <= 12; i++) { %>
                        <option value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>
            </div>

            <!-- Filtre par année -->
            <div class="col-md-3">
                <label for="yearFilter" class="form-label">Année</label>
                <select id="yearFilter" class="form-select">
                    <option value="">Toutes les années</option>
                    <% for (int year = 2000; year <= java.time.Year.now().getValue(); year++) { %>
                        <option value="<%= year %>"><%= year %></option>
                    <% } %>
                </select>
            </div>
        </div>

        <!-- Bouton de filtrage -->
        <div class="mt-3">
            <button type="button" id="filterButton" class="btn btn-primary">Appliquer les filtres</button>
        </div>
    </form>

    <!-- Tableau des produits et prix -->
    <table class="table table-bordered">
        <thead class="table-dark">
        <tr>
            <th>Produit</th>
            <th>Catégorie</th>
            <th>Prix</th>
            <th>Date</th>
        </tr>
        </thead>
        <tbody id="productTableBody">
        <% for (HistoPrixProduit produitPrix : produitPrixList) { %>
            <tr data-category="<%= produitPrix.getId_prod().getCategorie().getIdCategorie() %>" 
                data-date="<%= produitPrix.getDate_insert() %>" 
                data-month="<%= produitPrix.getDate_insert().toLocalDate().getMonthValue() %>" 
                data-year="<%= produitPrix.getDate_insert().toLocalDate().getYear() %>">
                <td><%= produitPrix.getId_prod().getNom() %></td>
                <td><%= produitPrix.getId_prod().getCategorie().getNom() %></td>
                <td><%= produitPrix.getPrix() %></td>
                <td><%= produitPrix.getDate_insert() %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<script>
    document.getElementById('filterButton').addEventListener('click', function () {
        const categoryFilter = document.getElementById('categoryFilter').value;
        const dateFilter = document.getElementById('dateFilter').value;
        const monthFilter = document.getElementById('monthFilter').value;
        const yearFilter = document.getElementById('yearFilter').value;

        const rows = document.querySelectorAll('#productTableBody tr');
        rows.forEach(row => {
            const category = row.getAttribute('data-category');
            const date = row.getAttribute('data-date');
            const month = row.getAttribute('data-month');
            const year = row.getAttribute('data-year');

            let show = true;

            if (categoryFilter && category !== categoryFilter) {
                show = false;
            }
            if (dateFilter && date !== dateFilter) {
                show = false;
            }
            if (monthFilter && month !== monthFilter) {
                show = false;
            }
            if (yearFilter && year !== yearFilter) {
                show = false;
            }

            row.style.display = show ? '' : 'none';
        });
    });
</script>

</body>
</html>
<%--  --%>