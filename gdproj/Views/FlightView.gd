extends MarginContainer
class_name FlightView

@export var DepartureSelection: OptionButton
@export var DestinationSelection: OptionButton

@onready var availableModulesList = $ChooseModules/ModuleChooser/AvailableColumn/MarginContainer/VBoxContainer/AvailableModules
@onready var selectedModulesList = $ChooseModules/ModuleChooser/SelectedColumn/MarginContainer/VBoxContainer/SelectedModules

func displayFlightView(planets: Array[Planet]):
	self.visible = true
	for planet in planets:
		print(planet)
		DepartureSelection.add_item(planet.name)
		DestinationSelection.add_item(planet.name)

func openRouteCreation():
	_flightController.displayRouteCreationPage()

func submitPlanets():
	_flightController.submitPlanets(DepartureSelection.get_selected_id(), DestinationSelection.get_selected_id())

func changeSpaceshipModules() -> void:
	_flightController.changeSpaceshipModules()

func displayAvailableModules(modules: Array[SpaceshipModule]):
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
	
	print(message)
	
	if not message:
		return
	
	_toast.show_message(message)
	
  
func openPage(page: int) -> void:
	for child in self.get_children():
		if child is CanvasItem:
			child.visible = false

	match page:
		1:
			if has_node("GenerateRoute"):
				$GenerateRoute.visible = true
		2:
			if has_node("ChooseModules"):
				$ChooseModules.visible = true
		3:
			if has_node("RouteView"):
				$RouteView.visible = true
		_:
			# fallback: show GenerateRoute if present
			if has_node("GenerateRoute"):
				$GenerateRoute.visible = true


func _generate_route_next() -> void:
	openPage(2)

func _choose_modules_back() -> void:
	openPage(1)

func _choose_modules_next() -> void:
	openPage(3)
