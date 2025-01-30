<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Categories> Categs = (List<Categories>) request.getAttribute("categories");
    List<Ingredients> Ingred = (List<Ingredients>) request.getAttribute("Ingredients"); 
    List<Produit> Produits = (List<Produit>) request.getAttribute("Produits");
    List<Fabrication> Fabrications = (List<Fabrication>) request.getAttribute("Fabrications");
    List<Vente> Ventes = (List<Vente>) request.getAttribute("ventes");
    List<Suggestion> suggestion = (List<Suggestion>) request.getAttribute("suggestion");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
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
     <link href="<%= request.getContextPath() %>/assets/css/vaovao.css" rel="stylesheet">
</head>

<body>
    <!-- Header -->
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
                    <li><a class="nav-link" href="#rapports">Rapports</a></li>
                    <li><a class="nav-link" href="<%= request.getContextPath() %>/CommissionServelet">Comms</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mt-5">
        <!-- Suggestions Section -->
        <section id="suggestions" class="mb-5">
            <h2>Suggestions</h2>
            <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addSuggestionModal">Ajouter une suggestion</button>
            
            <div class="filter-section">
                <div class="filter-group">
                    <div>
                        <strong><label>Date de debut</label></strong>
                        <input type="date" id="dateDebFilter" class="form-control">
                    </div>
                    <div>
                        <strong><label>Date de fin</label></strong>
                        <input type="date" id="dateFinFilter" class="form-control">
                    </div>
                    <div>
                        <strong><label>Annees</label></strong>
                        <input type="number" id="anneeFilter" class="form-control">
                    </div>
                    <div>
                        <strong><label>Categorie</label></strong>
                        <select id="categorySuggestionFilter" class="form-select">
                            <option value="all">Toutes les categories</option>
                            <% for (Categories cat : Categs) { %>
                                <option value="<%=cat.getNom()%>"><%=cat.getNom()%></option>
                            <% } %>
                        </select>
                    </div>
                </div>
            </div>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Produit</th>
                        <th>Date debut</th>
                        <th>Date fin</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody id="suggestionTableBody">
                    <% for (Suggestion sug : suggestion) { %>
                        <tr class="suggestion-item" data-category="<%= sug.getId_Produit().getCategorie().getNom() %>" data-datedeb="<%= sug.getDate_deb() %>" data-datefin="<%= sug.getDate_fin() %>">
                            <td><%= sug.getId_Produit().getNom() %></td>
                            <td><%= dateFormat.format(sug.getDate_deb()) %></td>
                            <td><%= dateFormat.format(sug.getDate_fin()) %></td>
                            <td><%= sug.getDescri() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

        <!-- Products Section -->
        <section id="produits" class="mb-5">
            <h2>Gestion des Produits</h2>
            <a href="histoPrix"> <button class="btn btn-success mb-3">Historique</button></a>
            <!-- Bouton pour ouvrir le modal -->
            <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#produitModal">
                Ajouter un produit
            </button>
            <button class="btn btn-warning btn-sm btn-modifier" data-bs-toggle="modal" data-bs-target="#modifierModal">
                Modifier
            </button>
            
            <div class="filter-section">
                <div class="filter-group">
                    <input type="text" id="searchInput" class="form-control" placeholder="Rechercher un produit...">
                    <select id="categoryFilter" class="form-select">
                        <option value="all">Toutes les categories</option>
                        <% for (Categories cat : Categs) { %>
                            <option value="<%=cat.getNom()%>"><%=cat.getNom()%></option>
                        <% } %>
                    </select>
                    <select id="ingredientFilter" class="form-select">
                        <option value="all">Tous les ingredients</option>
                        <% for (Ingredients ingredient : Ingred) { %>
                            <option value="<%=ingredient.getNom()%>"><%=ingredient.getNom()%></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Nom</th>
                        <th>Categorie</th>
                        <th>Stock</th>
                        <th>Prix de vente</th>
                       
                    </tr>
                </thead>
                <tbody>
                    <% for (Produit produit : Produits) {
                        List<Details_Recettes> detailsRecettes = produit.getRecette().getComposant();
                        List<String> ingredientNames = new ArrayList<>();
                        for (Details_Recettes detail : detailsRecettes) {
                            if (detail.getIngredients() != null) {
                                ingredientNames.add(detail.getIngredients().getNom());
                            }
                        }
                        String ingredientsStr = String.join(", ", ingredientNames);
                    %>
                        <tr class="product-item" data-ingredients="<%= ingredientsStr.toLowerCase() %>">
                            <td><%= produit.getNom() %></td>
                            <td><%= produit.getCategorie().getNom() %></td>
                            <td><%= produit.getstock() %></td>
                            <td><%= produit.getprixvente() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

        <!-- Ingredients Section -->
        <section id="ingredients" class="mb-5">
            <h2>Gestion des Ingredients</h2>
            <button class="btn btn-success mb-3">Ajouter un ingredient</button>
            
            <div class="filter-section">
                <input type="text" id="ingredientSearchInput" class="form-control" placeholder="Rechercher un ingredient...">
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
                    <% for (Ingredients ingredient : Ingred) { %>
                        <tr class="ingredient-item">
                            <td><%=ingredient.getNom()%></td>
                            <td><%=ingredient.getstock()%></td>
                            <td><%=ingredient.getUnite().getNom()%></td>
                            <td>
                                <button class="btn btn-warning btn-sm" data-bs-toggle="modal" 
                                        data-bs-target="#achatModal" data-id="<%=ingredient.getIdIngredients()%>">
                                    Ajouter
                                </button>
                                <button class="btn btn-danger btn-sm">Supprimer</button>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

        <!-- Fabrications Section -->
        <section id="fabrications" class="mb-5">
            <h2>Gestion des Fabrications</h2>
            <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#createFabricationModal">
                Fabriquer
            </button>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Produit</th>
                        <th>Quantite</th>
                        <th>Quantite reste</th>
                        <th>Date Fabrication</th>
                        <th>Cout Unitaire</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Fabrication fab : Fabrications) { %>
                        <tr>
                            <td><%=fab.getProduit().getNom()%></td>
                            <td><%=fab.getQttInitiale()%></td>
                            <td><%=fab.getQttReste()%></td>
                            <td><%=fab.getDtFabrique()%></td>
                            <td><%=fab.getCoutFabricationUnitaire()%></td>
                            <td>
                                <button class="btn btn-danger btn-sm">Supprimer</button>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

       <!-- Ventes Section -->
        <section id="ventes" class="mb-5">
            <h2>Gestion des Ventes</h2>
            <a href="VenteServlet" class="btn btn-primary mb-3">Enregistrer une vente</a>

            <div class="filter-section">
                <div class="filter-group">
                    <select id="catVente" class="form-select">
                        <option value="all">Toutes les categories</option>
                        <% for (Categories cat : Categs) { %>
                            <option value="<%=cat.getNom()%>"><%=cat.getNom()%></option>
                        <% } %>
                    </select>
                    <select id="natureFilter" class="form-select">
                        <option value="">Tous les types</option>
                        <option value="true">Produits Nature</option>
                        <option value="false">Produits Non-Nature</option>
                    </select>
                    <div>
                        <strong><label>Date de vente</label></strong>
                        <input type="date" id="dateVente" class="form-control">
                    </div>
                </div>
            </div>

            <table class="table table-striped" id="ventesTable">
                <thead>
                    <tr>
                        <th>Client</th>
                        <th>Date de vente</th>
                        <th>Total</th>
                        <th>Details</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Vente vente : Ventes) { %>
                        <tr class="vente-row">
                            <td><%= vente.getClient() != null ? vente.getClient().getNom() : "Client inconnu" %></td>
                            <td><%= dateFormat.format(vente.getDateVente()) %></td>
                            <td><%= String.format("%.2f", vente.getTotal()) %></td>
                            <td>
                                <table class="table table-sm table-bordered mb-0">
                                    <thead>
                                        <tr>
                                            <th>Produit</th>
                                            <th>Quantite</th>
                                            <th>Prix unitaire</th>
                                            <th>Sous-total</th>
                                            <th>Type</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Details_Ventes detail : vente.getComposant()) {
                                            Produit produit = detail.getIdProduit();
                                            if (produit != null && produit.getRecette() != null) {
                                                boolean hasNonNatureIngredient = false;
                                                boolean hasIngredients = false;
                                                
                                                for (Details_Recettes recetteDetail : produit.getRecette().getComposant()) {
                                                    if (recetteDetail.getIngredients() != null) {
                                                        hasIngredients = true;
                                                        if (recetteDetail.getIngredients().getIs_Nature()) {
                                                            hasNonNatureIngredient = true;
                                                            break;
                                                        }
                                                    }
                                                }
                                                
                                                boolean isNature = !(hasIngredients && hasNonNatureIngredient);
                                                double prixUnitaire = produit.getprixvente();
                                                double sousTotal = prixUnitaire * detail.getQtt();
                                        %>
                                            <tr data-nature="<%= isNature %>" 
                                                data-category="<%= produit.getCategorie() != null ? produit.getCategorie().getNom() : "" %>"
                                                data-date-vente="<%= dateFormat.format(vente.getDateVente()) %>">
                                                <td><%= produit.getNom() %></td>
                                                <td><%= detail.getQtt() %></td>
                                                <td><%= String.format("%.2f", prixUnitaire) %></td>
                                                <td><%= String.format("%.2f", sousTotal) %></td>
                                                <td><%= isNature ? "Nature" : "Non-Nature" %></td>
                                            </tr>
                                        <% }
                                        } %>
                                    </tbody>
                                </table>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm">Details</button>
                                <button class="btn btn-danger btn-sm">Supprimer</button>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

        <!-- Fournisseurs Section -->
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

        <!-- Stocks Section -->
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

        <!-- Rapports Section -->
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

    <!-- Modals -->
    <!-- Modal Fabrication -->
    <div class="modal fade" id="createFabricationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nouvelle Fabrication</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="CreateFabricationServlet" method="POST">
                        <div class="mb-3">
                            <label class="form-label">Produit</label>
                            <select class="form-select" name="produit" required>
                                <option value="">Selectionnez un produit</option>
                                <% for (Produit produit : Produits) { %>
                                    <option value="<%=produit.getId_Produit()%>"><%=produit.getNom()%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Quantite</label>
                            <input type="number" class="form-control" name="qtt" required min="1">
                        </div>
                        <button type="submit" class="btn btn-primary">Fabriquer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Achat -->
    <div class="modal fade" id="achatModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Acheter un ingredient</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="AchatServelet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="ingredients" id="ingredientsId">
                        <div class="mb-3">
                            <label class="form-label">Quantite</label>
                            <input type="number" class="form-control" name="qtt" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Prix</label>
                            <input type="number" class="form-control" name="prix" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date d'expiration</label>
                            <input type="date" class="form-control" name="date" required>
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

    <!-- Modal Suggestion -->
    <div class="modal fade" id="addSuggestionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="SuggestionServelet" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title">Ajouter une Suggestion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Produit</label>
                            <select name="produit" class="form-select" required>
                                <option value="">Selectionnez un produit</option>
                                <% for (Produit produit : Produits) { %>
                                    <option value="<%= produit.getId_Produit() %>">
                                        <%= produit.getNom() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date de fin</label>
                            <input type="date" name="date" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="descri" class="form-control" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>



<!-- Modal Ajout Produit -->
<div class="modal fade" id="produitModal" tabindex="-1" aria-labelledby="produitModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="produitModalLabel">Insertion produit</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="insertProduit" method="POST">
                <div class="modal-body">
                    <!-- Nom -->
                    <!-- Categorie -->
                    <div class="mb-3">
                        <label class="form-label">Categorie</label>
                        <select id="categorySuggestionFilter" class="form-select" name="categ" required>
                            <option value="all">Toutes les categories</option>
                            <% for (Categories cat : Categs) { %>
                                <option value="<%= cat.getIdCategorie() %>"><%= cat.getNom() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nom</label>
                        <input type="text" class="form-control" name="nom" required>
                    </div>
                    <!-- Prix -->
                    <div class="mb-3">
                        <label class="form-label">Prix</label>
                        <input type="number" class="form-control" name="prix" required>
                    </div>
                    <!-- Duree de conservation -->
                    <div class="mb-3">
                        <label class="form-label">Duree de conservation (en heures)</label>
                        <input type="number" class="form-control" name="duree" required>
                    </div>
                    <!-- Recette -->
                    <div class="mb-3">
                        <h3>Recette :</h3>
                        <div id="composantsContainer">
                            <!-- Composant Template -->
                            <div class="composant-item d-flex align-items-center mb-2">
                                <select class="form-select me-2" name="ingredients[]" required>
                                    <option value="" disabled selected>Choisir un ingrEdient</option>
                                    <% for (Ingredients ingredient : Ingred) { %>
                                        <option value="<%= ingredient.getIdIngredients() %>">
                                            <%= ingredient.getNom() %>
                                        </option>
                                    <% } %>
                                </select>
                                <input type="number" step="0.01" class="form-control me-2" name="quantites[]" placeholder="Quantite" required>
                                <button type="button" class="btn btn-danger remove-composant">Supprimer</button>
                            </div>
                        </div>
                        <!-- Bouton pour ajouter un composant -->
                        <button type="button" id="addComposantBtn" class="btn btn-secondary mt-3">Ajouter un Composant</button>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Creer</button>
                </div>
            </form>
        </div>
    </div>
</div>


<!-- Modal Modifier le prix -->
<div class="modal fade" id="modifierModal" tabindex="-1" aria-labelledby="modifierModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modifierModalLabel">Modifier le prix</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="Modifprod" method="POST">
                <div class="modal-body">

                    <label class="form-label">Produit</label>
                    <select class="form-select" name="produitId" required>
                        <option value="">Selectionnez un produit</option>
                        <% for (Produit produit : Produits) { %>
                            <option value="<%=produit.getId_Produit()%>"><%=produit.getNom()%></option>
                        <% } %>
                    </select>
                    <!-- Nouveau prix -->
                    <div class="mb-3">
                        <label class="form-label"> Nouveau Prix</label>
                        <input type="number" class="form-control" name="prix" id="produitPrix" step="0.01" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>


    <!-- Footer -->
    <footer class="footer bg-dark text-white text-center py-3">
        <p>&copy; 2025 Boulangerie matsiro</p>
    </footer>

    <!-- Scripts -->
    <script src="<%= request.getContextPath() %>/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <script>


            // Fonction utilitaire pour formater les dates
                function formatDate(dateString) {
                    if (!dateString) return '';
                    const date = new Date(dateString);
                    return date.toISOString().split('T')[0];
                }

                // Fonction utilitaire pour comparer les dates
                function compareDates(date1, date2) {
                    const d1 = new Date(date1);
                    const d2 = new Date(date2);
                    d1.setHours(0, 0, 0, 0);
                    d2.setHours(0, 0, 0, 0);
                    return d1.getTime() - d2.getTime();
                }

                // Filtres des produits
                function handleProductFilters() {
                    const searchInput = document.getElementById('searchInput').value.toLowerCase().trim();
                    const categoryFilter = document.getElementById('categoryFilter').value;
                    const ingredientFilter = document.getElementById('ingredientFilter').value;
                    
                    document.querySelectorAll('.product-item').forEach(row => {
                        const name = row.querySelector('td:first-child').textContent.toLowerCase();
                        const category = row.querySelector('td:nth-child(2)').textContent;
                        const ingredients = (row.dataset.ingredients || '').toLowerCase();
                        
                        const matchesSearch = searchInput === '' || name.includes(searchInput);
                        const matchesCategory = categoryFilter === 'all' || category === categoryFilter;
                        const matchesIngredient = ingredientFilter === 'all' || ingredients.includes(ingredientFilter.toLowerCase());
                        
                        row.style.display = (matchesSearch && matchesCategory && matchesIngredient) ? '' : 'none';
                    });
                }

                // Filtres des suggestions
                function handleSuggestionFilters() {
                    const dateDebValue = document.getElementById('dateDebFilter').value;
                    const dateFinValue = document.getElementById('dateFinFilter').value;
                    const categoryValue = document.getElementById('categorySuggestionFilter').value;
                    const annee = document.getElementById('anneeFilter').value;
                    
                    document.querySelectorAll('.suggestion-item').forEach(row => {
                        const dateDeb = formatDate(row.dataset.datedeb);
                        const dateFin = formatDate(row.dataset.datefin);
                        const category = row.dataset.category;
                        
                        const matchesDateDeb = !dateDebValue || compareDates(dateDeb, dateDebValue) >= 0;
                        const matchesDateFin = !dateFinValue || compareDates(dateFin, dateFinValue) <= 0;
                        const matchesCategory = categoryValue === 'all' || category === categoryValue;

                         const yearDeb = new Date(dateDeb).getFullYear();
                         const matchesYear = (annee===yearDeb)? true : false;
                        
                        row.style.display = (matchesDateDeb && matchesDateFin && matchesCategory && matchesYear) ? '' : 'block';
                    });
                }

                // Filtres des ventes
                function handleSalesFilters() {
                    const natureValue = document.getElementById('natureFilter').value;
                    const categoryValue = document.getElementById('catVente').value;
                    const dateValue = document.getElementById('dateVente').value;
                    
                    document.querySelectorAll('.vente-row').forEach(venteRow => {
                        let showRow = false;
                        const detailRows = venteRow.querySelectorAll('table tbody tr');
                        
                        detailRows.forEach(detailRow => {
                            const nature = detailRow.dataset.nature;
                            const category = detailRow.dataset.category;
                            const saleDate = detailRow.dataset.dateVente;
                            
                            const matchesNature = !natureValue || nature === natureValue;
                            const matchesCategory = categoryValue === 'all' || category === categoryValue;
                            const matchesDate = !dateValue || saleDate === dateValue;
                            
                            // If any detail row matches all filters, show the entire sale row
                            if (matchesNature && matchesCategory && matchesDate) {
                                showRow = true;
                            } 
                        });
                        
                        venteRow.style.display = showRow ? '' : 'none';
                    });
                }

                // Filtre des ingredients
                function handleIngredientSearch() {
                    const searchValue = document.getElementById('ingredientSearchInput').value.toLowerCase().trim();
                    
                    document.querySelectorAll('.ingredient-item').forEach(row => {
                        const name = row.querySelector('td:first-child').textContent.toLowerCase();
                        row.style.display = searchValue === '' || name.includes(searchValue) ? '' : 'none';
                    });
                }

                // Initialisation avec debounce pour ameliorer les performances
                function debounce(func, wait) {
                    let timeout;
                    return function executedFunction(...args) {
                        const later = () => {
                            clearTimeout(timeout);
                            func(...args);
                        };
                        clearTimeout(timeout);
                        timeout = setTimeout(later, wait);
                    };
                }

                document.addEventListener('DOMContentLoaded', function() {
                    // Appliquer le debounce aux fonctions de filtrage
                    const debouncedProductFilters = debounce(handleProductFilters, 250);
                    const debouncedSuggestionFilters = debounce(handleSuggestionFilters, 250);
                    const debouncedSalesFilters = debounce(handleSalesFilters, 250);
                    const debouncedIngredientSearch = debounce(handleIngredientSearch, 250);
                    
                    // ecouteurs d'evenements pour les filtres des produits
                    ['searchInput', 'categoryFilter', 'ingredientFilter'].forEach(id => {
                        const element = document.getElementById(id);
                        if (element) {
                            element.addEventListener('input', debouncedProductFilters);
                            element.addEventListener('change', debouncedProductFilters);
                        }
                    });

                    // ecouteurs d'evenements pour les filtres des suggestions
                    ['dateDebFilter', 'dateFinFilter', 'categorySuggestionFilter'].forEach(id => {
                        const element = document.getElementById(id);
                        if (element) {
                            element.addEventListener('input', debouncedSuggestionFilters);
                            element.addEventListener('change', debouncedSuggestionFilters);
                        }
                    });

                        // ecouteurs d'evenements pour les filtres des ventes
                    // Updated sales filter event listeners
                    ['natureFilter', 'catVente', 'dateVente'].forEach(id => {
                        const element = document.getElementById(id);
                        if (element) {
                            element.addEventListener('change', handleSalesFilters);
                            if (id === 'dateVente') {
                                element.addEventListener('input', handleSalesFilters);
                            }
                        }
                    });

                    // ecouteur d'evenements pour la recherche d'ingredients
                    const ingredientSearchInput = document.getElementById('ingredientSearchInput');
                    if (ingredientSearchInput) {
                        ingredientSearchInput.addEventListener('input', debouncedIngredientSearch);
                    }

                    // Modal Achat
                    const achatModal = document.getElementById('achatModal');
                    if (achatModal) {
                        achatModal.addEventListener('show.bs.modal', function(event) {
                            const button = event.relatedTarget;
                            const ingredientsId = button.dataset.id;
                            document.getElementById('ingredientsId').value = ingredientsId;
                        });
                    }

                    // Navigation active state
                    const navLinks = document.querySelectorAll('.nav-link');
                    navLinks.forEach(link => {
                        link.addEventListener('click', function() {
                            navLinks.forEach(l => l.classList.remove('active'));
                            this.classList.add('active');
                        });
                    });

                    // Initialiser les filtres au chargement
                    handleProductFilters();
                    handleSuggestionFilters();
                    handleSalesFilters();
                    handleIngredientSearch();
                });
        document.addEventListener('DOMContentLoaded', () => {
            const composantsContainer = document.getElementById('composantsContainer');
            const addComposantBtn = document.getElementById('addComposantBtn');

            // Ajouter un composant
            addComposantBtn.addEventListener('click', () => {
                const composantItem = document.createElement('div');
                composantItem.className = 'composant-item d-flex align-items-center mb-2';
                composantItem.innerHTML = `
                    <select class="form-select me-2" name="ingredients[]" required>
                        <option value="" disabled selected>Choisir un ingredient</option>
                        <% for (Ingredients ingredient : Ingred) { %>
                            <option value="<%= ingredient.getIdIngredients() %>"><%= ingredient.getNom() %></option>
                        <% } %>
                    </select>
                    <input type="number" step="0.01" class="form-control me-2" name="quantites[]" placeholder="Quantite" required>
                    <button type="button" class="btn btn-danger remove-composant">Supprimer</button>
                `;
                composantsContainer.appendChild(composantItem);
            });

            // Supprimer un composant
            composantsContainer.addEventListener('click', (e) => {
                if (e.target.classList.contains('remove-composant')) {
                    e.target.parentElement.remove();
                }
            });
        });




    </script>
</body>
</html>