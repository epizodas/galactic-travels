extends Node
class_name OrderController

func openOrdersPage():
	var user = _userController.getCurrentUser()
	var orders = Order.fetchUserOrders(user)
		
	var OrdersViewRef = get_tree().current_scene.find_child("OrdersView") as OrdersView
	OrdersViewRef.displayOrdersPage(orders)

func openSingleOrderPage(order_id: int):
	var OrdersViewRef = get_tree().current_scene.find_child("OrdersView") as OrdersView
	OrdersViewRef.visible = false
	
	var order = Order.fetchOrder(order_id)
	var cargo = Cargo.fetchOrderCargo(order_id)
	
	print(cargo)
	order.cargo = cargo
	
	var SingleOrderViewRef = get_tree().current_scene.find_child("SingleOrderView") as SingleOrderView
	SingleOrderViewRef.visible = true
	
	SingleOrderViewRef.displaySingleOrderPage(order)
	pass

func validateOrderData(cargos):
	for c in cargos:

		if c["name"].strip_edges().is_empty():
			return "Nenurodytas pavadinimas"

		if not str(c["length"]).is_valid_int():
			return "Ilgis turi būti skaičius"

		if int(c["length"]) <= 0:
			return "Ilgis turi būti > 0"

		if not str(c["width"]).is_valid_int():
			return "Plotis turi būti skaičius"

		if int(c["width"]) <= 0:
			return "Plotis turi būti > 0"

		if not str(c["mass"]).is_valid_int():
			return "Masė turi būti skaičius"

		if int(c["mass"]) <= 0:
			return "Masė turi būti > 0"

	var cargo_objects: Array[Cargo] = []
	for c in cargos:
		var cargo = Cargo.new(
			c["name"],
			int(c["length"]),
			int(c["width"]),
			int(c["mass"]),
			0 #order_id
		)
		cargo_objects.append(cargo)
	
	if (cargo_objects.size() == 0):
		return "Pridėkite krovinių"
	
	var user = _userController.getCurrentUser()
	var orderId: int = Order.addOrder(user.id)
	Cargo.addCargo(orderId, cargo_objects)
	
	var allCargo = Order.fetchUserOrders(user)
	var addOrderView = get_tree().current_scene.find_child("AddOrderView", true, false) as Control
	addOrderView.visible = false
	
	var orderView = get_tree().current_scene.find_child("OrdersView", true, false) as OrdersView
	orderView.displayOrdersPage(allCargo)
	


func submitEditOrder():
	pass

func unlockEditing():
	pass

func isOrderEditable():
	pass

func cancelOrder():
	pass

func isOrderCancellable():
	pass

func confirmCancellation():
	pass

func openAddOrderPage():
	var addOrderPage = get_tree().current_scene.find_child("AddOrderView") as AddOrderView
	addOrderPage.displayAddOrderPage()


# # ── State ────────────────────────────────────────────────────────────────────
# var _currentOrder: Order = null
# var _convertedPrice: float = 0.0
# var _selectedCurrency: String = "EUR"

# # ── Step 1–3: Open payment page ───────────────────────────────────────────────
# func openOrderPaymentPage(order_id: int) -> void:
# 	_currentOrder = Order.fetchOrder(order_id)
# 	if not _currentOrder:
# 		printerr("openOrderPaymentPage: order not found — id ", order_id)
# 		return

# 	_convertedPrice = _currentOrder.price
# 	_selectedCurrency = "EUR"

# 	var PaymentViewRef = get_tree().current_scene.find_child("PaymentView") as PaymentView
# 	if PaymentViewRef:
# 		PaymentViewRef.displayPaymentView(_currentOrder)

# # ── Steps 4–13: Currency conversion (opt block) ───────────────────────────────
# func submitCurrencyChange(currency: String) -> void:
# 	if not _currentOrder:
# 		printerr("submitCurrencyChange: no current order")
# 		return

# 	_selectedCurrency = currency
# 	var result = convertPrice(_currentOrder.price, currency)

# 	var PaymentViewRef = get_tree().current_scene.find_child("PaymentView") as PaymentView
# 	if not PaymentViewRef:
# 		return

# 	if result.has("price"):                        # steps 10–11: success
# 		_convertedPrice = result.price
# 		PaymentViewRef.displayConvertedPrice(result.price, currency)
# 	else:                                          # steps 12–13: error
# 		PaymentViewRef.displayCurrencyError(result.get("error", "Klaida konvertuojant valiutą"))

# func convertPrice(price: float, currency: String) -> Dictionary:
# 	# Calls ExchangeService → ExchangeAPI (steps 5–9)
# 	var converted = ExchangeService.convertPrice(price, currency)
# 	if converted < 0:
# 		return {"error": "Nepavyko gauti valiutos kurso"}
# 	return {"price": converted}

# # ── Steps 14–28: Process payment (alt block) ──────────────────────────────────
# func submitProcessPayment(payment_info: Dictionary) -> void:
# 	if not _currentOrder:
# 		printerr("submitProcessPayment: no current order")
# 		return

# 	var PaymentViewRef = get_tree().current_scene.find_child("PaymentView") as PaymentView

# 	# Steps 15–16: validate locally first
# 	var validation_error = validatePayment(payment_info)
# 	if validation_error:                           # outer alt [else] — steps 27–28
# 		if PaymentViewRef:
# 			PaymentViewRef.displayPaymentError(validation_error)
# 		return

# 	# Step 17: send to PaymentAPI via PaymentService
# 	var payment_status = PaymentService.processPayment(payment_info, _convertedPrice, _selectedCurrency)

# 	if payment_status == "success":                # inner alt [success]
# 		# Steps 21–22: update order status in DB
# 		updateOrderStatus(_currentOrder, "Sumokėtas")

# 		if PaymentViewRef:                         # steps 23–24: success message
# 			PaymentViewRef.displaySuccessMessage("Mokėjimas sėkmingai apdorotas")
# 	else:                                          # inner alt [else] — steps 25–26
# 		if PaymentViewRef:
# 			PaymentViewRef.displayPaymentError("Mokėjimo klaida: " + payment_status)

# func validatePayment(payment_info: Dictionary) -> String:
# 	# Steps 15–16: local validation before hitting PaymentAPI
# 	if not payment_info.has("card_number") or payment_info.card_number.strip_edges().is_empty():
# 		return "Nenurodytas kortelės numeris"
# 	if not payment_info.has("expiry") or payment_info.expiry.strip_edges().is_empty():
# 		return "Nenurodytas galiojimo laikas"
# 	if not payment_info.has("cvv") or payment_info.cvv.strip_edges().is_empty():
# 		return "Nenurodytas CVV"
# 	return "" # empty string = valid

# func updateOrderStatus(order: Order, status: String) -> void:
# 	# Steps 21–22
# 	order.order_status = status
# 	Order.updateOrderStatus(order.id, status)
