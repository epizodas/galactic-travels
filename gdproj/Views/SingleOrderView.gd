extends MarginContainer
class_name SingleOrderView

var order: Order = null

@onready var label: Label = $OrderView/HBoxContainer/Label
@onready var table: Tree = $OrderView/OrderCargo/ScrollContainer/Tree

func _createEditableEntry(internalName, prettyname, side: int, value = ""):
	var sideToAdd = $OrderView/OrderInfo/margin/HBoxContainer/Left if side == 0 else $OrderView/OrderInfo/margin/HBoxContainer/Right
	var container= HBoxContainer.new()
	container.name = internalName
	
	var label = Label.new()
	label.text = prettyname
	container.add_child(label)
	
	var inputbox = LineEdit.new()
	inputbox.size_flags_horizontal |= Control.SIZE_EXPAND
	if value:
		inputbox.text = str(value)
	inputbox.name = "value"
	container.add_child(inputbox) 
	
	sideToAdd.add_child(container)
	
func _ready():
	setup_table_columns()
	
func setup_table_columns():
	table.columns = 4
	table.column_titles_visible = true
	table.hide_root = true
	table.select_mode = Tree.SELECT_ROW
	
	table.set_column_title(0, "Pavadinimas")
	table.set_column_title(1, "Ilgis")
	table.set_column_title(2, "Plotis")
	table.set_column_title(3, "Masė")


func displaySingleOrderPage(p_order: Order):
	order = p_order
	
	var status = ""
	for st in Order.Status:
		if Order.Status.get(st) == order.status:
			status = str(st)
			break
	
	label.text = "Užsakymas Nr." + str(order.id)
	_createEditableEntry("status", "Statusas", 0, status)
	_createEditableEntry("price", "Kaina", 1, str(order.price))
	
	table.clear()
	var root = table.create_item()
	table.hide_root = true
	
	print(order.cargo)
	
	for item in order.cargo:
		var row = table.create_item(root)
		row.set_text(0, item.name)
		row.set_text(1, str(item.length) + "cm")
		row.set_text(2, str(item.width) + "cm")
		row.set_text(3, str(item.mass) + "kg")
		
