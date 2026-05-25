extends MarginContainer
class_name OrdersView

@onready var table: Tree = $Orders/container/ScrollContainer/Tree

func _ready():
	_setup_table_columns()
	table.button_clicked.connect(_on_table_button_clicked)
	
func _setup_table_columns():
	table.columns = 4
	table.column_titles_visible = true
	table.hide_root = true
	table.select_mode = Tree.SELECT_ROW
	
	table.set_column_title(0, "Nr.")
	table.set_column_title(1, "Kaina")
	table.set_column_title(2, "Būsena")
	table.set_column_title(3, "Veiksmai")
	
	table.set_column_expand(0, true)
	table.set_column_expand(1, true)
	table.set_column_expand(2, true)
	table.set_column_expand(3, true)


func displayOrdersPage(orders: Array[Order]):
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	_mainView.visible = false
	self.visible = true
	
	table.clear()
	var root = table.create_item()
	table.hide_root = true
	
	for order in orders:
		var status = ""
		
		match order.order_status:
			1: status = "Užsakytas"
			2: status = "Patvirtintas"
			3: status = "Apmokėtas"
			4: status = "Užbaigtas"
			5: status = "Atšauktas"
			
		var row = table.create_item(root)
		row.set_text_alignment(0, HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER)
		row.set_text_alignment(1, HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER)
		row.set_text_alignment(2, HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER)
		row.set_text_alignment(3, HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER)
		row.set_text(0, str(order.id))
		row.set_text(1, str(order.price))
		row.set_text(2, status)
		row.add_button(3, preload("res://edit.svg"), 0, false, "Peržiūrėti")		
		row.set_metadata(0, order.id)

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
	_orderController.openAddOrderPage();
	
	
func _on_table_button_clicked(item: TreeItem, column: int, id: int, mouse_button: int):
	var order = item.get_metadata(0)
	if column == 3:
		_orderController.openSingleOrderPage(order)

func _back():
	var view = get_tree().current_scene.find_child("MainView", true, false) as Control

	if view:
		view.visible = true

	self.visible = false
