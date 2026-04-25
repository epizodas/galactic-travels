extends MarginContainer
class_name AddSpaceshipView

func _createEditableEntry(internalName, prettyname, side: int, value = ""):
	var sideToAdd = $SpaceObjects/container/margin/HBoxContainer/Left if side == 0 else $SpaceObjects/container/margin/HBoxContainer/Right
	var container = HBoxContainer.new()
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
	pass
	
func _getEditableEntryValue(internalName) -> String:
	var container = self.find_child(internalName, true, false) as Control
	var inputbox = container.get_child(1) as LineEdit
	return inputbox.text
	
func displayAddSpaceshipView():
	_createEditableEntry("name", "Pavadinimas", 0)
	_createEditableEntry("speed", "Greitis", 1)
	_createEditableEntry("maxTemp", "Maksimali temperatūra", 0)
	_createEditableEntry("cargoLength", "Bagažo skyriaus ilgis", 1)
	_createEditableEntry("cargoWidth", "Bagažo skyriaus plotis", 0)
	_createEditableEntry("category", "Kategorija", 1)
	_createEditableEntry("fuelCapacity", "Kuro talpos dydis", 0)
	_createEditableEntry("fuelConsumption", "Kuro sąnaudos", 1)
	_createEditableEntry("moduleCapacity", "Palaikomų modulių kiekis", 0)
	var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
	SpaceshipViewRef.visible = false
	self.visible = true
	pass

func submitSpaceshipData():
	var code = "SHP-" + str(randi_range(1, 1000))
	
	var spaceship = Spaceship.new(
		self._getEditableEntryValue("name"),
		code,
		float(self._getEditableEntryValue("speed")),
		float(self._getEditableEntryValue("maxTemp")),
		int(self._getEditableEntryValue("cargoLength")),
		int(self._getEditableEntryValue("cargoWidth")),
		Spaceship.Category.get(self._getEditableEntryValue("category")),
		float(self._getEditableEntryValue("fuelCapacity")),
		float(self._getEditableEntryValue("fuelConsumption")),
		int(self._getEditableEntryValue("moduleCapacity")),
	)

	_spaceshipController.submitSpaceshipData(spaceship)

func closeEdit():
	self.visible = false
	var containers: Array[Node] = [
		$SpaceObjects/container/margin/HBoxContainer/Left,
		$SpaceObjects/container/margin/HBoxContainer/Right
	]
	for container in containers:
		for child in container.get_children():
			child.queue_free()
	
	var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
	SpaceshipViewRef.visible = true
	
func cancel():
	_spaceshipController.cancelAddSpaceship()
	pass

func submitSpaceship() -> void:
	pass # Replace with function body.
