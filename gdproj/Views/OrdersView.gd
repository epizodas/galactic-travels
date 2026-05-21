extends MarginContainer
class_name OrdersView

@onready var table: Tree = $Orders/container/ScrollContainer/Tree

func _ready():
	setup_table_columns()
	table.button_clicked.connect(_on_table_button_clicked)
	
func setup_table_columns():
	table.columns = 5
	table.column_titles_visible = true
	table.hide_root = true
	table.select_mode = Tree.SELECT_ROW
	
	table.set_column_title(0, "Nr.")
	table.set_column_title(1, "Kaina")
	table.set_column_title(2, "Statusas")
	table.set_column_title(3, "Atidaryti")


func displayOrdersPage(orders: Array[Order]):
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	_mainView.visible = false
	self.visible = true
	openOrdersTable(orders)

func openOrdersTable(orders: Array[Order]):
	table.clear()
	var root = table.create_item()
	table.hide_root = true
	
	for order in orders:
		var status = ""
		for st in Order.Status:
			if Order.Status.get(st) == order.status:
				status = str(st)
				break
			
		var row = table.create_item(root)
		row.set_text(0, str(order.id))
		row.set_text(1, str(order.price))
		row.set_text(2, status)
		row.add_button(3, preload("res://edit.svg"), 0, false, "Edit")
		#row.add_button(4, preload("res://trash.svg"), 0, false, "Remove")
		
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
	pass
	
	
func _on_table_button_clicked(item: TreeItem, column: int, id: int, mouse_button: int):
	var order = item.get_metadata(0)
	if column == 3:
		_orderController.openSingleOrderPage(order)
