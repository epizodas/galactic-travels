extends MarginContainer
class_name FlightView
@export var DepartureSelection: OptionButton
@export var DestinationSelection: OptionButton

@onready var availableModulesList = $ChooseModules/ModuleChooser/AvailableColumn/MarginContainer/VBoxContainer/AvailableModules
@onready var selectedModulesList = $ChooseModules/ModuleChooser/SelectedColumn/MarginContainer/VBoxContainer/SelectedModules

func displayFlightView(planets: Array[Planet]):
	self.visible = true
	for planet in planets:
		DepartureSelection.add_item(planet.name)
		DestinationSelection.add_item(planet.name)

func openRouteCreation():
	_flightController.displayRouteCreationPage()

func openFlightOptimalCargoView():
	_flightController.displayFlightOptimalCargoView()

var spaceships: Array[Spaceship]

func unlockSpaceshipSelect(spaceships: Array[Spaceship]):
	self.spaceships = spaceships
	for spaceship in spaceships:
		$GenerateRoute/Spaceship/Selection.add_item(spaceship.name)
		
	$GenerateRoute/Spaceship/Selection.disabled = false
	pass

func submitPlanets(index):
	var spaceships = _flightController.submitPlanets(DepartureSelection.get_selected_id(), DestinationSelection.get_selected_id())
	if len(spaceships) <= 0:
		_toast.show_message("Nėra erdvėlaivių planetoje")
		$GenerateRoute/Spaceship/Selection.disabled = true
	else:
		unlockSpaceshipSelect(spaceships)

func changeSpaceshipModules() -> void:
	_flightController.changeSpaceshipModules()

func submit():
	_flightController.submit()

func displayAvailableModules(modules: Array[SpaceshipModule]):
	$ChooseModules.visible = true
	$GenerateRoute.visible = false
	
	availableModulesList.clear()
	selectedModulesList.clear()

	var selectedModules: Array[SpaceshipModule] = _flightController.getSelectedModules()
		
	for module in modules:
		if selectedModules.has(module):
			selectedModulesList.add_module(module)
		else:
			availableModulesList.add_module(module)

func selectModule(module: SpaceshipModule) -> void:
	_flightController.selectModule(module)

func deselectModule(module: SpaceshipModule) -> void:
	_flightController.deselectModule(module)

func submitModules() -> void:
	var message = _flightController.submitModules()
	
	$ChooseModules.visible = false
	$GenerateRoute.visible = true
	
	print(message)
	
	if not message:
		return
	
	_toast.show_message(message)
	
func unlockButtons():
	pass

func submitSpaceship(index: int) -> void:
	if _flightController.submitSpaceship(spaceships[index]):
		unlockButtons()
	pass

func displayFlightCostView() -> void:
	$GenerateRoute.visible = false
	$CalcOrderCosts.visible = true

func openFlightCostView() -> void:
	_flightController.openFlightCostView()

func _back_from_costs() -> void:
	$GenerateRoute.visible = true
	$CalcOrderCosts.visible = false
	pass

func submitCostInfo() -> void:
	var kg = $CalcOrderCosts/LineEdit.text.to_float()
	var sqm = $CalcOrderCosts/LineEdit2.text.to_float()
	var mrg = $CalcOrderCosts/LineEdit3.text.to_float()

	var result = null
	result = _flightController.submitCostInfo(kg, sqm, mrg)

	if result == null:
		$CalcOrderCosts/Label4.text = "Neteisingi įvesties duomenys"
		return

	$CalcOrderCosts/Label4.text = "Pelnas: " + str(result)
	
func _back():
	var view = get_tree().current_scene.find_child("MainView", true, false) as Control
	if view:
		view.visible = true
	self.visible = false
	
