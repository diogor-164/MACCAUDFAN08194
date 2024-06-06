<?php
// Database connection
$servername = "localhost";
$username = "root"; // Replace with your MySQL username
$password = "root"; // Replace with your MySQL password
$database = "fcmonthey_caisse";
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the latest transaction ID and increment it for the new order
$sql = "SELECT id_transaction FROM tbltransactions ORDER BY date_transaction DESC LIMIT 1";
$result = $conn->query($sql);
$new_order_number = 1; // Default value if no transactions found

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $latest_transaction_id = $row["id_transaction"];
    $new_order_number = $latest_transaction_id + 1;
}

// Fetch categories and items
$data = array();
$sql = "SELECT c.id_categorie, c.nom_categorie, p.id_produit, p.nom_produit, p.prix_vente
        FROM tblcategories c
        LEFT JOIN tblproduits p ON c.id_categorie = p.id_categorie
        ORDER BY c.id_categorie, p.id_produit";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $currentCategory = null;
    while ($row = $result->fetch_assoc()) {
        $categoryID = $row['id_categorie'];
        $categoryName = $row['nom_categorie'];
        
        if ($currentCategory !== $categoryID) {
            $data[$categoryName] = array();
            $currentCategory = $categoryID;
        }
        
        if (!empty($row['id_produit'])) {
            $data[$categoryName][] = array(
                'id' => $row['id_produit'],
                'name' => $row['nom_produit'],
                'price' => $row['prix_vente']
            );
        }
    }
}

$conn->close();
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prototype Caisse</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
    <style>
        .side-panel {
            width: 300px;
            right: -300px;
            top: 0;
            transition: right 0.3s;
        }

        .side-panel.open {
            right: 0;
        }

        .side-panel #togglePanelBtn {
            position: absolute;
            left: -40px;
            top: 20px;
        }

        .quantity {
            display: inline-block;
            width: 50px;
            margin-left: 10px;
        }

        .nav-tabs .nav-link.active {
            background-color: #e9ecef;
        }
        
        .quantity-buttons {
            display: inline-flex;
            align-items: center;
        }

        .quantity-buttons button {
            width: 30px;
            height: 30px;
            line-height: 0;
            padding: 0;
            margin: 0 5px;
            text-align: center;
        }
		

		
		
    </style>
</head>
<body>
    <div class="container mt-5">
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            <?php
            if (!empty($data)) {
                $firstCategory = true;
                foreach ($data as $categoryName => $items) {
                    echo '<li class="nav-item">';
                    echo '<a class="nav-link' . ($firstCategory ? ' active' : '') . '" id="' . $categoryName . '-tab" data-toggle="tab" href="#' . $categoryName . '" role="tab" aria-controls="' . $categoryName . '" aria-selected="' . ($firstCategory ? 'true' : 'false') . '">' . $categoryName . '</a>';
                    echo '</li>';
                    $firstCategory = false;
                }
            } else {
                echo '<li class="nav-item">No categories found</li>';
            }
            ?>
        </ul>

        <div class="tab-content mt-4" id="myTabContent">
            <?php
            if (!empty($data)) {
                $firstCategory = true;
                foreach ($data as $categoryName => $items) {
                    echo '<div class="tab-pane fade' . ($firstCategory ? ' show active' : '') . '" id="' . $categoryName . '" role="tabpanel" aria-labelledby="' . $categoryName . '-tab">';
                    echo '<div class="row">';
                    foreach ($items as $item) {
                        echo '<div class="col-md-6">';
                        echo '<div class="card mb-4">';
                        echo '<div class="card-body" data-name="' . $item['name'] . '" data-price="' . $item['price'] . '" data-id="' . $item['id'] . '">';
                        echo '<h5 class="card-title">' . $item['name'] . '</h5>';
                        echo '<p class="card-text">Prix: ' . $item['price'] . ' CHF</p>';
                        echo '<button class="btn btn-primary add-to-cart">Ajouter au panier</button>';
                        echo '</div>';
                        echo '</div>';
                        echo '</div>';
                    }
                    echo '</div>';
                    echo '</div>';
                    $firstCategory = false;
                }
            } else {
                echo '<div class="tab-pane fade show active" id="no-categories" role="tabpanel" aria-labelledby="no-categories-tab">';
                echo 'No categories found';
                echo '</div>';
            }
            ?>
        </div>
    </div>

    <!-- Side Panel for Order Summary -->
    <div id="sidePanel" class="position-fixed side-panel h-100 overflow-auto bg-light">
        <button id="togglePanelBtn" class="btn btn-secondary">&laquo;</button>
        <div class="p-3">
            <h3>Résumé de la commande</h3>
            <h5>N° commande: <?php echo $new_order_number; ?></h5>
            <ul class="list-group" id="orderSummary"></ul>
            <p class="mt-3 font-weight-bold">TOTAL: <span id="totalPrice">0</span> CHF
                <button id="validateOrderBtn" class="btn btn-primary float-right">Valider commande</button>
            </p>
        </div>
    </div>

    <!-- Modal for Payment Method -->
	<div class="modal fade" id="paymentMethodModal" tabindex="-1" role="dialog" aria-labelledby="paymentMethodModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="paymentMethodModalLabel">Sélectionnez le mode de paiement</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" id="payment_method">
					<button type="button" class="btn btn-primary btn-block" data-dismiss="modal" data-payment-method-id="1" value="1">TWINT</button>
					<button type="button" class="btn btn-primary btn-block" data-dismiss="modal" data-payment-method-id="2" value="2">CASH</button>
				</div>
			</div>
		</div>
	</div>

    <!-- Toggle Basket Button -->
    <button id="togglePanelBtnMain" class="btn btn-secondary position-fixed" style="top: 20px; right: 20px;">Afficher le panier</button>

    <script>
        $(document).ready(function() {
            let orderSummary = $("#orderSummary");
            let totalPriceElement = $("#totalPrice");
            let totalPrice = 0;

            $(".add-to-cart").click(function() {
                let cardBody = $(this).closest(".card-body");
                let itemName = cardBody.data("name");
                let itemPrice = parseFloat(cardBody.data("price"));
                let itemId = cardBody.data("id");

                let existingItem = orderSummary.find(`li[data-id="${itemId}"]`);
                if (existingItem.length > 0) {
                    let quantityInput = existingItem.find(".quantity");
                    quantityInput.val(parseInt(quantityInput.val()) + 1);
                } else {
                    let listItem = $("<li class='list-group-item d-flex justify-content-between align-items-center'></li>");
                    listItem.text(itemName + " - " + itemPrice + " CHF");

					
					let quantityInput = $('<input type="number" id=qty_art_'+itemId+' class="quantity form-control" value="1" min="1">').data("price", itemPrice);
					let quantityButtons = $('<div class="quantity-buttons"></div>');
                    let plusButton = $('<button class="btn btn-success btn-sm">+</button>');
                    let minusButton = $('<button class="btn btn-danger btn-sm">-</button>');

                    plusButton.click(function() {
                        quantityInput.val(parseInt(quantityInput.val()) + 1);
                        updateTotalPrice();
                    });

                    minusButton.click(function() {
                        if (quantityInput.val() > 1) {
                            quantityInput.val(parseInt(quantityInput.val()) - 1);
                        } else {
                            listItem.remove();
                        }
                        updateTotalPrice();
                    });

                    quantityButtons.append(minusButton).append(quantityInput).append(plusButton);
                    listItem.append(quantityButtons);
                    listItem.attr("data-id", itemId).attr("data-price", itemPrice);
                    orderSummary.append(listItem);
                }

                updateTotalPrice();
            });

            $("#validateOrderBtn").click(function() {
                $("#paymentMethodModal").modal("show");
            });

            $("#togglePanelBtn").click(function() {
                $("#sidePanel").toggleClass("open");
                $(this).text($("#sidePanel").hasClass("open") ? '»' : '«');
            });

            $("#togglePanelBtnMain").click(function() {
                $("#sidePanel").toggleClass("open");
                $("#togglePanelBtn").text($("#sidePanel").hasClass("open") ? '»' : '«');
            });

            function updateTotalPrice() {
                totalPrice = 0;
                orderSummary.find("li").each(function() {
                    let quantity = $(this).find(".quantity").val();
                    let itemPrice = $(this).data("price");
                    totalPrice += itemPrice * quantity;
                });
                totalPriceElement.text(totalPrice.toFixed(2));
            }
			
			$("#paymentMethodModal .btn").click(function() {
				let id_moyenpaiement = $(this).val();
				let finalPrice = $("#totalPrice").text();
				insertTransactionData(id_moyenpaiement, <?php echo $new_order_number; ?>, finalPrice);
			});

            function insertTransactionData(paymentMethod, orderNumber, price) {
                let transactionQuery = `INSERT INTO tbltransactions (id_moyenpaiement, total_transaction) VALUES (${paymentMethod}, ${price})`;
                $.post('process.php', { query: transactionQuery }, function(response) {
                    if (response === "Query executed successfully.") {
                        orderSummary.find("li").each(function() {
                            let itemId = $(this).data("id");
							alert(itemId);
                            let quantity = $('#qty_art_' + itemId).val();
                            let price = $(this).data("price");
							let finalPrice = price * quantity;
                            let labelQuery = `INSERT INTO tbllibelle (id_transaction, id_produit, quantite_libelle, sous_total) VALUES (${orderNumber}, ${itemId}, ${quantity}, ${finalPrice})`;
							alert(labelQuery);
                            $.post('process.php', { query: labelQuery });
                        });
                        alert("Commande validée avec succès!");
                        location.reload();
                    } else {
                        alert("Erreur lors de la validation de la commande: " + response);
                    }
                });
            }
        });
    </script>
</body>
</html>
