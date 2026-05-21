extends Node
class_name OrderController

func openOrdersPage():
	var user = _userController.getCurrentUser()
	var orders = Order.fetchUserOrders(user)
	
	var OrdersViewRef = get_tree().current_scene.find_child("OrdersView") as OrdersView
	OrdersViewRef.displayOrdersPage(orders)

func openSingleOrderPage():
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
