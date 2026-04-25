extends Node
class_name SpaceshipController

func openSpaceshipTable():
	var spaceship_list: Array[Spaceship] = Spaceship.fetchAllSpaceships()
	var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
	print(spaceship_list)
	SpaceshipViewRef.displaySpaceshipsPage(spaceship_list)
	pass

func validateSpaceship(_ship: Spaceship):
	return Time.get_ticks_msec() % 2 == 0 # Not yet implemented

func errorMessage(msg: String):
	print("Error: ", msg)

func checkInUse(_ship: Spaceship) -> bool:
	return Time.get_ticks_msec() % 2 == 0 # Not yet implemented

func openSpaceshipEdit(shipId):
	var ship = Spaceship.getSpaceship(shipId)
	var inUse = checkInUse(ship)
	if !inUse:
		var EditSpaceshipViewRef = get_tree().current_scene.find_child("EditSpaceshipView") as EditSpaceshipView
		EditSpaceshipViewRef.openEditSpaceshipView(ship)
		pass
	else:
		# TODO error message
		pass

func submit():
	pass

func saveSpaceship(): # TODO add ship arg, actual checking
	var isValid = validateSpaceship(null)
	if isValid:
		Spaceship.updateSpaceship(null)
		var EditSpaceshipViewRef = get_tree().current_scene.find_child("EditSpaceshipView") as EditSpaceshipView
		Spaceship.updateSpaceship(null)
		EditSpaceshipViewRef.closeEdit()
	else:
		# TODO error message
		pass
	pass

func cancel(): # TODO really descriptive name
	var EditSpaceshipViewRef = get_tree().current_scene.find_child("EditSpaceshipView") as EditSpaceshipView
	EditSpaceshipViewRef.closeEdit()
	
func openAddSpaceshipPage():
	var AddSpaceshipViewRef = get_tree().current_scene.find_child("AddSpaceshipView") as AddSpaceshipView
	AddSpaceshipViewRef.displayAddSpaceshipView()

func validateSpaceshipData(_ship: Spaceship):
	return Time.get_ticks_msec() % 2 == 0 # Not yet implemented

func submitSpaceshipData(ship: Spaceship):
	var valid = validateSpaceship(ship)
	if valid:
		print("Data is valid")
		Spaceship.addSpaceship(ship)
		var spaceships = Spaceship.fetchAllSpaceships()
		var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
		SpaceshipViewRef.displaySpaceshipsPage(spaceships)
		var AddSpaceshipViewRef = get_tree().current_scene.find_child("AddSpaceshipView") as AddSpaceshipView
		AddSpaceshipViewRef.visible = false
	pass
	
	
