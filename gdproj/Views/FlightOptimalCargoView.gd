extends Node
class_name FlightOptimalCargoView

@onready var error_field = $VBoxContainer/HBoxContainer/Error
@onready var results_container = $VBoxContainer/VBoxContainer


func displayFlightOptimalCargoView():
	var flight_view = get_tree().current_scene.find_child("FlightView", true, false)
	if flight_view:
		flight_view.visible = false
	self.visible = true
	error_field.text = ""

func pressCalculateButton():
	var ret = _flightController.calculateOptimalCargo()

	if typeof(ret) == TYPE_STRING:
		error_field.text = ret
		return

	error_field.text = ""

	# clear old rows
	for child in results_container.get_children():
		child.queue_free()

	# ---- HEADER ROW ----
	var header = HBoxContainer.new()

	var id_header = Label.new()
	id_header.text = "ID"
	id_header.custom_minimum_size.x = 100

	var length_header = Label.new()
	length_header.text = "Krovinio ilgis"
	length_header.custom_minimum_size.x = 150

	var width_header = Label.new()
	width_header.text = "Krovinio plotis"
	width_header.custom_minimum_size.x = 150

	header.add_child(id_header)
	header.add_child(length_header)
	header.add_child(width_header)

	results_container.add_child(header)

	for cargo in ret:
		var row = HBoxContainer.new()

		var id_label = Label.new()
		id_label.text = str(cargo.id)
		id_label.custom_minimum_size.x = 100

		var length_label = Label.new()
		length_label.text = str(cargo.length)
		length_label.custom_minimum_size.x = 150

		var width_label = Label.new()
		width_label.text = str(cargo.width)
		width_label.custom_minimum_size.x = 150

		row.add_child(id_label)
		row.add_child(length_label)
		row.add_child(width_label)

		results_container.add_child(row)

func _back():
	var flight_view = get_tree().current_scene.find_child("FlightView", true, false)
	if flight_view:
		flight_view.visible = true
	self.visible = false
	pass
