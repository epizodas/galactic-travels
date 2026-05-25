extends Control
class_name AddOrderView

@onready var cargo_rows = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var error_field = $VBoxContainer/Bar/Label

func _ready() -> void:
	addCargo()

func displayAddOrderPage():
	var orders_view = get_tree().current_scene.find_child("OrdersView", true, false)

	if orders_view:
		orders_view.visible = false

	self.visible = true

	# clear cargo rows
	for child in cargo_rows.get_children():
		child.queue_free()

func submitOrderAdd():
	var cargos: Array = []

	for row in cargo_rows.get_children():
		var name_field = row.get_node("name") as LineEdit
		var length_field = row.get_node("length") as LineEdit
		var width_field = row.get_node("width") as LineEdit
		var mass_field = row.get_node("mass") as LineEdit

		var cargo_data = {
			"name": name_field.text.strip_edges(),
			"length": length_field.text,
			"width": width_field.text,
			"mass": mass_field.text
		}

		cargos.append(cargo_data)

	var message = _orderController.validateOrderData(cargos)
	if(message != null):
		error_field.text = message;
	


func addCargo():
	var row = HBoxContainer.new()

	# Pavadinimas
	var cargo_name = LineEdit.new()
	cargo_name.name = "name"
	cargo_name.placeholder_text = "Pavadinimas"
	cargo_name.custom_minimum_size.x = 150
	row.add_child(cargo_name)

	# Ilgis
	var length = LineEdit.new()
	length.name = "length"
	length.placeholder_text = "Ilgis"
	length.custom_minimum_size.x = 80
	row.add_child(length)

	# Plotis
	var width = LineEdit.new()
	width.name = "width"
	width.placeholder_text = "Plotis"
	width.custom_minimum_size.x = 100
	row.add_child(width)

	# Masė
	var mass = LineEdit.new()
	mass.name = "mass"
	mass.placeholder_text = "Masė"
	mass.custom_minimum_size.x = 100
	row.add_child(mass)

	cargo_rows.add_child(row)


func removeCargo():
	if cargo_rows.get_child_count() <= 1:
		return

	var last_row = cargo_rows.get_child(cargo_rows.get_child_count() - 1)
	last_row.queue_free()

func _back():
	var view = get_tree().current_scene.find_child("OrdersView", true, false) as Control

	if view:
		view.visible = true

	self.visible = false
