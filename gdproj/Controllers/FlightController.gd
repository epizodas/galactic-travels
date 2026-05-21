extends Node
class_name FlightController

var _planets: Array[SpaceBody] = []
var _spaceship: Spaceship = null

var _selectedModules: Array[SpaceshipModule] = []

func openFlightView():
	var planets: Array[Planet] = Planet.fetchAllPlanets()
	print(len(planets))

	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.visible = false
	
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView(planets)

func rememberPlanets():
	pass

func submitPlanets():
	rememberPlanets()
	printerr("Sita tikrai matysit, TODO submitPlanets()")
	#Planet.getPlanetHangar()
	pass

func getRememberedPlanets():
	pass
	
func getRememberedSpaceship():
	pass
	
func getRoute():
	return null
	
func selectModule(module: SpaceshipModule):
	if not _selectedModules.has(module):
		_selectedModules.append(module)
	
func deselectModule(module: SpaceshipModule):
	_selectedModules.erase(module)

func getSelectedModules() -> Array[SpaceshipModule]:
	return _selectedModules.duplicate()

func changeSpaceshipModules():
	var moduleTypes = SpaceshipModule.Type
	
	var availableModules: Array[SpaceshipModule] = []
	
	for type in moduleTypes:
		var mod_type = SpaceshipModule.Type.get(type)
		var module = Hangar.getSpaceshipModuleByType(mod_type)
		
		if not module:
			continue
		
		availableModules.append(module)
	
	var route = getRoute()
	
	if route:
		var shieldModule = availableModules.find_custom(func(m): return m.type == SpaceshipModule.Type.Sheld)
		if shieldModule:
			selectModule(shieldModule)
	
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	print(availableModules)
	FlightViewRef.displayAvailableModules(availableModules)

func submitModules():
	var selected_modules = getSelectedModules()
	
	if _spaceship:
		var ok = _spaceship.assignModules(selected_modules)
		if not ok:
			pass
	
	var speedModule = selected_modules.find_custom(func(m): return m.type == SpaceshipModule.Type.Speed)
	if speedModule != -1:
		return "Reikia pergeneruoti maršrutą"
		
	return null

func getRememberedNeededFuel():
	pass

func calculateTotalCosts():
	var totalCost = 0.0
	for module in _selectedModules:
		totalCost += module.cost
	return totalCost
