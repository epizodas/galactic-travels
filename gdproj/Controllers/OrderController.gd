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

func validateOrderData():
	pass

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
	pass

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
