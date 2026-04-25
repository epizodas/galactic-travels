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
  
func openSpaceshipEdit(code: String):
	var ship = Spaceship.getSpaceship(code)
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

func saveSpaceship(ship: Spaceship): # TODO add ship arg, actual checking
	var isValid = validateSpaceship(ship)
	if isValid:
		Spaceship.updateSpaceship(ship)
		
		var EditSpaceshipViewRef = get_tree().current_scene.find_child("EditSpaceshipView") as EditSpaceshipView
		EditSpaceshipViewRef.closeEdit()
		
		var spaceships = Spaceship.fetchAllSpaceships()
		var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
		SpaceshipViewRef.displaySpaceshipsPage(spaceships)
	else:
		# TODO error message
		pass
	pass

func cancelEditSpaceship(): # TODO really descriptive name
	var EditSpaceshipViewRef = get_tree().current_scene.find_child("EditSpaceshipView") as EditSpaceshipView
	EditSpaceshipViewRef.closeEdit()
	
func cancelAddSpaceship():
	var AddSpaceshipViewRef = get_tree().current_scene.find_child("AddSpaceshipView") as AddSpaceshipView
	AddSpaceshipViewRef.closeEdit()
	
func openAddSpaceshipPage():
	var AddSpaceshipViewRef = get_tree().current_scene.find_child("AddSpaceshipView") as AddSpaceshipView
	AddSpaceshipViewRef.displayAddSpaceshipView()

func validateSpaceshipData(ship: Spaceship):
	return (
		ship.name.length() > 0
		and ship.speed > 0
		and ship.fuelCapacity > 0
		and ship.fuelConsumption > 0
		and ship.moduleCapacity >= 0
	)

func submitSpaceshipData(ship: Spaceship):
	var isValid = validateSpaceship(ship)
	if isValid:
		Spaceship.addSpaceship(ship)
		var spaceships = Spaceship.fetchAllSpaceships()
		var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
		SpaceshipViewRef.displaySpaceshipsPage(spaceships)
		var AddSpaceshipViewRef = get_tree().current_scene.find_child("AddSpaceshipView") as AddSpaceshipView
		AddSpaceshipViewRef.visible = false
	pass

func removeSpaceship(code: String):
	Spaceship.deleteSpaceship(code)
	var spaceships = Spaceship.fetchAllSpaceships()
	var SpaceshipViewRef = get_tree().current_scene.find_child("SpaceshipView") as SpaceshipView
	SpaceshipViewRef.displaySpaceshipsPage(spaceships)
