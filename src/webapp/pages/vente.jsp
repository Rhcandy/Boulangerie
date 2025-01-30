<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<%
    List<Produit> Produits = (List<Produit>) request.getAttribute("Produits");
    List<Employe> Emps = (List<Employe>) request.getAttribute("Vendeur");
    List<Clients> kils = (List<Clients>) request.getAttribute("Clients");
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
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/main.css" rel="stylesheet">

    <script>
        let totalPanier = 0;

        // Ajouter une ligne dans le tableau
        function addCreanceField() {
            const panierTableBody = document.getElementById('panierContainer');
            const newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td>
                    <select name="ProduitsId[]" class="form-control produitSelect" onchange="updatePrice(this)" required>
                        <% if (Produits != null && !Produits.isEmpty()) { %>
                            <% for (Produit produit : Produits) { %>
                                <option value="<%=produit.getId_Produit()%>" data-prix="<%=produit.getprixvente()%>" data-stock="<%=produit.getstock()%>">
                                    <%=produit.getNom()%>%> 
                                </option>
                            <% } %>
                        <% } else { %>
                            <option value="">Aucun produit disponible en magasin</option>
                        <% } %>
                    </select>
                </td>
                <td class="prixUnitaire">0.00</td>
                <td>
                    <input type="number" class="form-control creanceAmount" name="ProduitsQtt[]" placeholder="Quantité" oninput="updateTotal()" min="0" required>
                </td>
                <td class="sousTotal">0.00</td>
                <td>
                    <button type="button" class="btn btn-danger btn-sm" onclick="removeField(this)">Supprimer</button>
                </td>
            `;
            panierTableBody.appendChild(newRow);
        }

        // Mettre à jour les prix et le total
        function updatePrice(selectElement) {
            const selectedOption = selectElement.options[selectElement.selectedIndex];
            const prixUnitaire = parseFloat(selectedOption.getAttribute('data-prix')) || 0;
            const maxStock = parseInt(selectedOption.getAttribute('data-stock')) || 0;
            const row = selectElement.closest('tr');
            const qttField = row.querySelector('.creanceAmount');
            const prixUnitaireCell = row.querySelector('.prixUnitaire');

            qttField.setAttribute('max', maxStock);
            qttField.value = ''; // Réinitialiser la quantité
            prixUnitaireCell.textContent = prixUnitaire.toFixed(2);

            updateTotal();
        }

        // Recalculer le total
        function updateTotal() {
            totalPanier = 0;
            const rows = document.querySelectorAll('#panierContainer tr');
            rows.forEach(row => {
                const prixUnitaire = parseFloat(row.querySelector('.prixUnitaire').textContent) || 0;
                const qtt = parseInt(row.querySelector('.creanceAmount').value) || 0;
                const sousTotalCell = row.querySelector('.sousTotal');

                const sousTotal = prixUnitaire * qtt;
                sousTotalCell.textContent = sousTotal.toFixed(2);

                totalPanier += sousTotal;
            });

            document.getElementById('totalPanier').textContent = `Total du panier : ${totalPanier.toFixed(2)} `;
        }

        // Supprimer une ligne du tableau
        function removeField(button) {
            const field = button.closest('tr');
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
                <div class="mb-3">
                    <label for="vendeur" class="form-label">Vendeur</label>
                    <select name="Vendeur" id="vendeur" class="form-control">
                        <% for (Employe emp : Emps) { %>
                            <option value="<%=emp.getId_Employe()%>">
                                <%=emp.getNom()%>
                            </option>
                        <% } %>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="client" class="form-label">Client</label>
                    <select name="client" id="client" class="form-control">
                        <% for (Clients kil : kils) { %>
                            <option value="<%=kil.getId_Client()%>">
                                <%=kil.getNom()%>
                            </option>
                        <% } %>
                    </select>
                </div>

                <!-- Panier -->
                <div class="card shadow-sm mt-4">
                    <div class="card-header bg-primary text-white text-center">
                        <h5>Panier</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered text-center align-middle" id="panierTable">
                                <thead class="bg-light">
                                    <tr>
                                        <th>Produit</th>
                                        <th>Prix Unitaire</th>
                                        <th>Quantite</th>
                                        <th>Sous-total</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="panierContainer">
                                    <!-- Produits ajoutés dynamiquement -->
                                </tbody>
                            </table>
                        </div>
                        <div class="mt-3 text-end">
                            <h5 id="totalPanier" class="fw-bold">Total du panier : 0.00 </h5>
                        </div>
                        <button type="button" class="btn btn-secondary mt-3" onclick="addCreanceField()">Ajouter un produit</button>
                    </div>
                </div>

                <input type="hidden" name="total" id="hiddenTotal">
                <button type="submit" class="btn btn-primary w-100 mt-3" onclick="document.getElementById('hiddenTotal').value = totalPanier;">Valider Panier</button>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer bg-dark text-white text-center py-3">
        <p>&copy; 2025 Boulangerie Matsiro</p>
    </footer>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>

</html>
