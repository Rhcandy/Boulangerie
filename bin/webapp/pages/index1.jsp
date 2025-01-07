<%@ page import="model.*" %>
<%@ page import="com.google.gson.Gson" %>

<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title >Boulangerie - Gestion</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">

  <link href="assets/css/main.css" rel="stylesheet">
</head>

<body>
  <header id="header" class="header d-flex align-items-center sticky-top"  style="background-color: rgb(155, 79, 79);">
    <div class="container d-flex align-items-center justify-content-between">
      <a href="#" class="logo d-flex align-items-center">
        <h1 style="color:white;">Boulangerie</h1>
      </a>
      <nav class="navbar">
        <ul class="nav">
          <li><a class="nav-link active" href="#produits">Produits</a></li>
          <li><a class="nav-link" href="#ingredients">Ingredients</a></li>
          <li><a class="nav-link" href="#fabrications">Fabrications</a></li>
          <li><a class="nav-link" href="#ventes">Ventes</a></li>
          <li><a class="nav-link" href="#fournisseurs">Fournisseurs</a></li>
          <li><a class="nav-link" href="#stocks">Stocks</a></li>
          <li><a class="nav-link" href="#rapports">Rapports</a></li>
          <li-><a class="nav-link" href="client.html">Interface client</a></li->
        </ul>
      </nav>
    </div>
  </header>

  <!-- Contenu principal -->
  <main class="container mt-5">

    <!-- Gestion des Produits -->
    <section id="produits" class="mb-5">
      <h2>Gestion des Produits</h2>
      <div class="d-flex justify-content-between mb-3">
        <button class="btn btn-success">Ajouter un produit</button>
        <input type="text" class="form-control w-50" placeholder="Rechercher un produit...">
      </div>
       <div class="d-flex justify-content-between mb-3">
        <input type="text" id="searchInput" class="form-control w-50" placeholder="Rechercher un produit...">
        <select id="categoryFilter" class="form-select w-25">
          <option value="all">Toutes les catégories</option>
          <%
            List<Categories> Categs = (List<Categories>) request.getAttribute("categories");
            for (Categories cat : Categs) {
          %>
          <option value="<%=cat.getNom()%>"><%=cat.getNom()%></option>
         <% } %>
        </select>

        <select id="ingredientFilter" class="form-select w-25">
          <option value="all">Tous les ingrédients</option>
          <%
            List<Ingredients> Ingred = (List<Ingredients>) request.getAttribute("Ingredients");
            for (Ingredients ingredient : Ingred) {
          %>
          <option value="<%=ingredient.getNom()%>"><%=ingredient.getNom()%></option>
         <% } %>
        </select>
      </div>

      <table class="table table-striped">
        <thead>
          <tr>
            <th>Nom</th>
            <th>Categorie</th>
            <th>Stock</th>
            <th>Prix de vente </th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <%
            List<Produit> Produits = (List<Produit>) request.getAttribute("Produits");
            
            for (Produit produit : Produits) {
               List<Details_Recettes> detailsRecettes = produit.getRecette().getComposant();
                List<String> ingredientNames = new ArrayList<>();
                for (Details_Recettes detail : detailsRecettes) {
                    Ingredients ingredient = detail.getIngredients();
                    ingredientNames.add(ingredient.getNom());
                }
                String ingredientsStr = String.join(", ", ingredientNames);
          
        %>
            <tr class="product-item" data-ingredients="<%= ingredientsStr.toLowerCase() %>">
              <td><%=produit.getNom()%></td> <!-- Afficher le nom du produit -->
              <td><%=produit.getCategorie().getNom()%></td> <!-- Afficher la catégorie du produit -->
              <td><%=produit.getstock()%></td> <!-- Afficher le stock du produit -->
              <td><%=produit.getprixvente()%></td> <!-- Afficher le prix de vente du produit -->
              <td>
                <button class="btn btn-warning">Modifier</button>
                <button class="btn btn-danger">Supprimer</button>
              </td>
            </tr>
          <% } %>
        </tbody>
      </table>
    </section>

    <!-- Gestion des Ingredients -->
    <section id="ingredients" class="mb-5">
      <h2>Gestion des Ingredients</h2>
      <div class="d-flex justify-content-between mb-3">
        <button class="btn btn-success">Ajouter un ingredient</button>
        <input type="text" class="form-control w-50" placeholder="Rechercher un ingrédient...">
      </div>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Nom</th>
            <th>Unite</th>
            <th>Stock</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <%
            List<Ingredients> Ingreds = (List<Ingredients>) request.getAttribute("Ingredients");
            for (Ingredients ingredient : Ingreds) {
        %>
            <tr>
              <td><%=ingredient.getNom()%></td> 
              <td><%=ingredient.getUnite().getNom()%></td>
              <td><%=ingredient.getstock()%></td> 
              <td>
                <button class="btn btn-warning">Modifier</button>
                <button class="btn btn-danger">Supprimer</button>
              </td>
            </tr>
          <% } %>
        </tbody>
      </table>
    </section>

    <!-- Gestion des Fabrications -->
    <section id="fabrications" class="mb-5">
      <h2>Gestion des Fabrications</h2>
      <button class="btn btn-primary mb-3">Creer un plan de fabrication</button>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Produit</th>
            <th>Quantite</th>
            <th>Quantite reste </th>
            <th>Date Fabrications </th>
            <th>Cout Unitaire de Fabrications </th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <%
            List<Fabrication> Fabrications = (List<Fabrication>) request.getAttribute("Fabrications");
            for (Fabrication Fabrication : Fabrications) {
        %>
            <tr>
              <td><%=Fabrication.getProduit().getNom()%></td> <!-- Afficher le nom du Fabrication -->
              <td><%=Fabrication.getQttInitiale()%></td> <!-- Afficher la catégorie du Fabrication -->
              <td><%=Fabrication.getQttReste()%></td> <!-- Afficher le stock du Fabrication -->
              <td><%=Fabrication.getDtFabrique()%></td>
              <td><%=Fabrication.getCoutFabricationUnitaire()%></td>
              <td>
                <button class="btn btn-danger">Supprimer</button>
              </td>
            </tr>
        <% } %>
        </tbody>
      </table>
    </section>

    <!-- Gestion des Ventes -->
    <section id="ventes" class="mb-5">
      <h2>Gestion des Ventes</h2>
      <button class="btn btn-primary mb-3">Enregistrer une vente</button>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Produit</th>
            <th>Quantite</th>
            <th>Prix Total</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- VENTES -->
        </tbody>
      </table>
    </section>

    <!-- Gestion des Fournisseurs -->
    <section id="fournisseurs" class="mb-5">
      <h2>Gestion des Fournisseurs</h2>
      <button class="btn btn-success mb-3">Ajouter un fournisseur</button>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Nom</th>
            <th>Contact</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- FOURNISSEURS -->
        </tbody>
      </table>
    </section>

    <!-- Gestion des Stocks -->
    <section id="stocks" class="mb-5">
      <h2>Gestion des Stocks</h2>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Type</th>
            <th>Nom</th>
            <th>Quantite</th>
            <th>Unite</th>
          </tr>
        </thead>
        <tbody>
          <!-- STOCKS -->
        </tbody>
      </table>
    </section>

    <!-- Rapports et Statistiques -->
    <section id="rapports">
      <h2>Rapports et Statistiques</h2>
      <button class="btn btn-info mb-3">Generer un rapport</button>
      <div class="card">
        <div class="card-body">
          <h5>Statistiques</h5>
          <p>Affichez ici les produits les plus vendus, les benefices, etc.</p>
        </div>
      </div>
    </section>

  </main>

  <!-- Footer -->
  <footer class="footer bg-dark text-white text-center py-3">
    <p>&copy; 2025 Boulangerie matsiro</p>
  </footer>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
      // Gestion du filtre par catégorie
      document.getElementById('categoryFilter').addEventListener('change', function () {
        const selectedCategory = this.value.toLowerCase();
        filterProducts();
      });

      // Gestion de la recherche par nom
      document.getElementById('searchInput').addEventListener('input', function () {
        filterProducts();
      });

      // Gestion du filtre par ingrédient
      document.getElementById('ingredientFilter').addEventListener('change', function () {
        filterProducts();
      });

      // Fonction principale pour filtrer les produits
      function filterProducts() {
        const selectedCategory = document.getElementById('categoryFilter').value.toLowerCase();
        const searchText = document.getElementById('searchInput').value.toLowerCase();
        const selectedIngredient = document.getElementById('ingredientFilter').value.toLowerCase();

        const rows = document.querySelectorAll('tbody tr'); // Les lignes du tableau

        rows.forEach(row => {
          const productName = row.querySelector('td:first-child').textContent.toLowerCase();
          const category = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
          const ingredients = row.dataset.ingredients ? row.dataset.ingredients.toLowerCase() : ''; // Récupère les ingrédients de l'attribut `data-ingredients`

          // Logique de filtrage
          const matchesCategory = selectedCategory === 'all' || category.includes(selectedCategory);
          const matchesSearch = searchText === '' || productName.includes(searchText);
          const matchesIngredient = selectedIngredient === 'all' || ingredients.includes(selectedIngredient);

          // Affiche ou masque la ligne en fonction des critères
          if (matchesCategory && matchesSearch && matchesIngredient) {
            row.style.display = '';
          } else {
            row.style.display = 'none';
          }
        });
      }
</script>


</body>

</html>
