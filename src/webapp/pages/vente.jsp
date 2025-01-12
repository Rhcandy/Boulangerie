<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<%
 List<Produit> Produits = (List<Produit>) request.getAttribute("Produits");
%>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Boulangerie</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/css/main.css" rel="stylesheet">

  <script>
    let totalPanier = 0;

        // Mettre à jour le prix unitaire et calculer le total
      function updatePrice(selectElement) {
        const selectedOption = selectElement.options[selectElement.selectedIndex];
        const prixUnitaire = parseFloat(selectedOption.getAttribute('data-prix')) || 0;
        const maxStock = parseInt(selectedOption.getAttribute('data-stock')) || 0;
        const qttField = selectElement.closest('.form-row').querySelector('.creanceAmount');
        const hiddenPrixField = selectElement.closest('.form-row').querySelector('.hiddenPrixUnitaire');

        qttField.setAttribute('max', maxStock);
        qttField.setAttribute('min', 0);
        qttField.value = ''; // Réinitialiser la quantité
        hiddenPrixField.value = prixUnitaire; // Mettre à jour le prix unitaire

        updateTotal();
      }


    // Recalculer le total de la facture
    function updateTotal() {
        totalPanier = 0;
        const rows = document.querySelectorAll('#panierContainer .form-row');

        rows.forEach(row => {
            const selectElement = row.querySelector('.produitSelect');
            const selectedOption = selectElement.options[selectElement.selectedIndex];
            const prixUnitaire = parseFloat(selectedOption.getAttribute('data-prix')) || 0;
            const qtt = parseInt(row.querySelector('.creanceAmount').value) || 0;

            totalPanier += prixUnitaire * qtt;
        });

        document.getElementById('totalPanier').textContent = `Total du panier : ${totalPanier.toFixed(2)} €`;
    }

    // Ajouter un champ de produit
    function addCreanceField() {
        const creanceContainer = document.getElementById('panierContainer');
        const newField = document.createElement('div');
        newField.className = "form-row mb-12";
        newField.innerHTML = `
            <div class="col-md-4">
                <select name="ProduitsId[]" class="form-control produitSelect" onchange="updatePrice(this)" required>
                    <% if (Produits != null && !Produits.isEmpty()) { %>
                        <% for (Produit produit : Produits) { %>
                            <option value="<%=produit.getId_Produit()%>" data-prix="<%=produit.getprixvente()%>" data-stock="<%=produit.getstock()%>">
                                <%=produit.getNom()%> - <%=produit.getprixvente()%> \u20AC
                            </option>
                        <% } %>
                    <% } else { %>
                        <option value="">Aucun produit disponible en magasin</option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-1">
                <input type="number" class="form-control creanceAmount" name="ProduitsQtt[]" placeholder="Quantité" oninput="updateTotal()" required>
                <input type="hidden" name="ProduitsPrix[]" class="hiddenPrixUnitaire">
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-danger" onclick="removeField(this)">Supprimer</button>
            </div>
        `;

        creanceContainer.appendChild(newField);
    }

    // Supprimer un champ de produit
    function removeField(button) {
        const field = button.closest('.form-row');
        field.remove();
        updateTotal();
    }
  </script>
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

  <!-- Main Content -->
  <main class="container mt-5">
    <div class="container">
        <h2 class="form-title text-center">Enregistrer Vente</h2>
        <form action="VenteServlet" method="POST">
            <div>
                <div id="panierContainer"></div>
                <button type="button" class="btn btn-secondary mb-3" onclick="addCreanceField()">Ajouter un produit</button>
            </div>
            <input type="hidden" name="total" id="hiddenTotal">
            <button type="submit" class="btn btn-primary w-100" onclick="document.getElementById('hiddenTotal').value = totalPanier;">Valider Panier</button>
        </form>
        <div id="totalPanier" class="text-center mt-4" style="font-size: 1.2em; font-weight: bold;">
            Total du panier : 0.00 €
        </div>
    </div>
  </main>

  <!-- Footer -->
  <footer class="footer bg-dark text-white text-center py-3">
    <p>&copy; 2025 Boulangerie matsiro</p>
  </footer>

  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>

</html>



