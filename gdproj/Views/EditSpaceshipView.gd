extends MarginContainer
class_name EditSpaceshipView

func _createEditableEntry(internalName, prettyname, side: int, value = ""):
	var sideToAdd = $SpaceObjects/container/margin/HBoxContainer/Left if side == 0 else $SpaceObjects/container/margin/HBoxContainer/Right
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
	pass
	
func openEditSpaceshipView(ship: Spaceship):
	_createEditableEntry("name", "Pavadinimas", 0, ship.name)
	_createEditableEntry("speed", "Greitis", 1, ship.speed)
	_createEditableEntry("maxTemp", "Maksimali temperatūra", 0, ship.maxTemp)
	_createEditableEntry("cargoLength", "Bagažo skyriaus ilgis", 1, ship.cargoLength)
	_createEditableEntry("cargoWidth", "Bagažo skyriaus plotis", 0, ship.cargoWidth)
	_createEditableEntry("category", "Kategorija", 1, ship.category)
	_createEditableEntry("fuelCapacity", "Kuro talpos dydis", 0, ship.fuelCapacity)
	_createEditableEntry("fuelConsumption", "Kuro sąnaudos", 1, ship.fuelConsumption)
	_createEditableEntry("moduleCapacity", "Palaikomų modulių kiekis", 0, ship.moduleCapacity)
	var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
	SpaceshipViewRef.visible = false
	self.visible = true
	pass

func submit():
	# 02:30 AM audrius cia, nemanau kad reikejo isvis submit, nes tiesiog nelogiskai viskas veiks
	# :)
	# Bet jau tiesiog per velu kazka pakeist, noriu miego, redbullis dar sistemoje
	_spaceshipController.submit()

func saveSpaceship():
	_spaceshipController.saveSpaceship()
	
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
	_spaceshipController.cancel()
	pass
