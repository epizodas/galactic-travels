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

func submitOrderAdd():
	pass

func cancelCancellation():
	pass

func openOrderPaymentPage():
	pass

func convertPrice():
	pass

func validatePayment():
	pass
