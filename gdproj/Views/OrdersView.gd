extends MarginContainer
class_name OrdersView

func displayOrdersPage():
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	_mainView.visible = false
	self.visible = true
	pass

func openSingleOrdersPage():
	pass

func selectOrder():
	pass

func cancelOrder():
	pass

func showCancellationConfirmation():
	pass

func confirmCancellation():
	pass

func cancelCancellation():
	pass

func closeCancellationConfirmation():
	pass

func openAddOrderPage():
	pass
