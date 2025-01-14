<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<%
 List<Categories> Categs = (List<Categories>) request.getAttribute("categories");
 List<Ingredients> Ingred = (List<Ingredients>) request.getAttribute("Ingredients"); 
 List<Produit> Produits = (List<Produit>) request.getAttribute("Produits");
 List<Fabrication> Fabrications = (List<Fabrication>) request.getAttribute("Fabrications");
 List<Vente> Ventes = (List<Vente>) request.getAttribute("ventes");
%>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Boulangerie - Gestion</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <link href="<%= request.getContextPath() %>/assets/img/favicon.png" rel="icon">
  <link href="<%= request.getContextPath() %>/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <link href="<%= request.getContextPath() %>/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="<%= request.getContextPath() %>/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">

  <link href="<%= request.getContextPath() %>/assets/css/main.css" rel="stylesheet">
</head>

<body>
  
  <header id="header" class="header d-flex align-items-center sticky-top">
    <div class="container d-flex align-items-center justify-content-between">
      <a href="#" class="logo d-flex align-items-center">
        <h1>Boulangerie</h1>
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
      </div>
       <div class="d-flex justify-content-between mb-3">
        <input type="text" id="searchInput" class="form-control w-50" placeholder="Rechercher un produit...">
        <select id="categoryFilter" class="form-select w-25">
          <option value="all">Toutes les categories</option>
          <%
            for (Categories cat : Categs) {
          %>
          <option value="<%=cat.getNom()%>"><%=cat.getNom()%></option>
         <% } %>
        </select>

        <select id="ingredientFilter" class="form-select w-25">
          <option value="all">Tous les ingredients</option>
          <%
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
            <th>Stock</th>
            <th>Unite</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <%
            for (Ingredients ingredient : Ingred) {
        %>
            <tr>
              <td><%=ingredient.getNom()%></td> 
              <td><%=ingredient.getstock()%></td> 
              <td><%=ingredient.getUnite().getNom()%></td>
              <td>
                <button class="btn btn-warning"data-bs-toggle="modal" data-bs-target="#achatModal" data-id="<%=ingredient.getIdIngredients()%>">Ajouter</button>
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
      <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#createFabricationModal">
        Fabriquer
      </button>
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

    <!-- Gestion des Détails des Ventes avec Filtre -->
<section id="ventes" class="mb-5">
  <h2>Gestion des Details des Ventes</h2>
   <a href="VenteServlet" >
      <button class="btn btn-primary mb-3">Enregistrer une vente</button>
    </a>
  <!-- Formulaire de filtrage -->
  <form id="filterForm">
    <label for="natureFilter">Filtrer par Ingredients Nature :</label>
    <select id="natureFilter" class="form-control">
      <option value="">-- Selectionner --</option>
      <option value="true">Ingredients Nature</option>
      <option value="false">Ingredients Non-Nature</option>
    </select>
  </form>
  
  <table class="table table-striped" id="ventesTable">
    <thead>
      <tr>
        <th>Id Vente</th>
        <th>Id Detail Vente</th>
        <th>Produit</th>
        <th>Quantite</th>
        <th>Prix Total</th>
        <th>Ingredient Nature</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% 
        for (Vente vente : Ventes) {
          List<Details_Ventes> detailsVentes = vente.getComposant();
          for (Details_Ventes detail : detailsVentes) {
            Ingredients ingredient = null;
            boolean isNature = true;  // Initialiser comme 'true' (le produit est "nature" par défaut)
            
            // Vérifier les ingrédients de la recette du produit
            if (detail.getIdProduit() != null && detail.getIdProduit().getRecette() != null) {
              for (Details_Recettes recetteDetail : detail.getIdProduit().getRecette().getComposant()) {
                ingredient = recetteDetail.getIngredients();
                if (ingredient != null && ingredient.getIs_Nature()) {
                  isNature = false;  // Si un ingrédient est de type 'nature', alors le produit est non-nature
                  break; // Une fois trouvé un ingrédient 'nature', on peut arrêter la recherche
                }
              }
            }
      %>
        <tr class="product-item" data-vente-id="<%= detail.getIdVente() %>" data-nature="<%= isNature %>">
          <td><%= detail.getIdVente() %></td>
          <td><%= detail.getIdDetailsVentes() %></td>
          <td><%= detail.getIdProduit() != null ? detail.getIdProduit().getNom() : "Inconnu" %></td>
          <td><%= detail.getQtt() %></td>
          <td><%= detail.getIdProduit() != null ? detail.getIdProduit().getprixvente() * detail.getQtt() : 0 %></td>
          <td><%= isNature ? "Nature" : "Non-Nature" %></td>
          <td>
            <button onclick="" class="btn btn-success">Btn</button>
          </td>
        </tr>
      <% 
          } // Fin du for sur Details_Ventes
        } // Fin du for sur Ventes
      %>
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

  <!-- Modal pour créer une nouvelle fabrication -->
  <div class="modal fade" id="createFabricationModal" tabindex="-1" aria-labelledby="createFabricationModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="createFabricationModalLabel">Fabrication</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <!-- Formulaire pour créer une fabrication -->
        <form action="CreateFabricationServlet" method="POST">
          <div class="mb-3">
            <select class="form-select"  name="produit" required>
              <option value="">Selectionnez un produit</option>
              <%
                for (Produit produit : Produits) {
              %>
                <option value="<%=produit.getId_Produit()%>"><%=produit.getNom()%></option>
              <% } %>
            </select>
          </div>
          <div class="mb-3">
            <label for="qtt" class="form-label">Quantite</label>
            <input type="number" class="form-control"  name="qtt" required min="1">
          </div>
          <input type="submit" class="btn btn-primary" value="Fabriquer">
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
      </div>
    </div>
  </div>
  </div>

  <%-- Modal pour achat  --%>
  <div class="modal fade" id="achatModal" tabindex="-1" aria-labelledby="achatModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="achatModalLabel">Acheter un ingrédient</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="AchatServelet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="ingredients" id="ingredientsId">
                        <div class="mb-3">
                            <label for="qtt" class="form-label">Quantite</label>
                            <input type="number" class="form-control" id="qtt" name="qtt" required>
                        </div>
                        <div class="mb-3">
                            <label for="prix" class="form-label">Prix</label>
                            <input type="number" class="form-control" id="prix" name="prix" required>
                        </div>
                        <div class="mb-3">
                            <label for="date" class="form-label">Date d'expiration</label>
                            <input type="date" class="form-control" id="date" name="date" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Acheter</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

  </main>

  <!-- Footer -->
  <footer class="footer bg-dark text-white text-center py-3">
    <p>&copy; 2025 Boulangerie matsiro</p>
  </footer>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script>
       // Ajout dynamique de l'ID d'ingrédient au formulaire dans le modal
      document.getElementById('achatModal').addEventListener('show.bs.modal', function (event) {
          const button = event.relatedTarget; // Bouton qui a déclenché le modal
          const ingredientsId = button.getAttribute('data-id'); // Récupération de l'ID
          const modalInput = document.getElementById('ingredientsId'); 
          modalInput.value = ingredientsId; // Ajout de l'ID dans le champ caché
      });
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


      // Filtrage en fonction de la sélection de l'utilisateur
      document.getElementById('natureFilter').addEventListener('change', function() {
          let filterValue = this.value;  // true / false / "" (vide pour tout afficher)
          let rows = document.querySelectorAll('#ventesTable tbody tr');

          rows.forEach(row => {
              let isNature = row.getAttribute('data-nature') === 'true'; // Vérifier si cet ingrédient est nature
              if (filterValue === "" || (filterValue === "true" && isNature) || (filterValue === "false" && !isNature)) {
                  row.style.display = '';  // Afficher la ligne
              } else {
                  row.style.display = 'none';  // Cacher la ligne
              }
          });
      });
      
  </script>
</body>

</html>
