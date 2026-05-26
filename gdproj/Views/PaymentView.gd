extends Node
class_name PaymentView
var _currentOrder = null

func _on_price_converted(converted_price: float, currency: String) -> void:
	var price_label = find_child("price", true, false) as Label
	price_label.text = "Užsakymo kaina: " + str(converted_price) + " " + currency

func displayPaymentView(order: Order):
	var orders_view = get_tree().current_scene.find_child("SingleOrderView", true, false)
	if orders_view:
		orders_view.visible = false
	self.visible = true
	
	_currentOrder = order
	
	var initial_price = find_child("price", true, false) as Label
	initial_price.text = "Užsakymo kaina: " + str(order.price) + " EUR"

	
	var option_button = find_child("currency", true, false)
	if option_button:
		option_button.clear()  # Remove existing items first
	option_button.add_item("AUD")
	option_button.add_item("YEN")
	option_button.add_item("USD")

func submitCurrencyChange() -> void:
	var option_button = find_child("currency", true, false)
	
	if option_button == null or _currentOrder == null:
		return

	var selected_currency = option_button.get_item_text(option_button.selected)

	var newPrice = _orderController.convertPrice(_currentOrder.price, selected_currency)
	
	$VBoxContainer/newPrice.text = "Nauja užsakymo kaina: " + str(newPrice) + " " + selected_currency


func submitProcessPayment():
	var msg = _orderController.processPayment(_currentOrder)
	_toast.show(msg)
	pass

func _back():
	var orders_view = get_tree().current_scene.find_child("SingleOrderView", true, false)
	if orders_view:
		orders_view.visible = true

	self.visible = false
