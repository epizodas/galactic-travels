extends Node
class_name FlightController

var _planets = null
var _spaceship = null

var _selectedModules = []

func openFlightView():
	var planets = Planet.fetchAllPlanets()
	
	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.visible = false
	
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView()

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
	_selectedModules.append(module)
	
func deselectModule(module: SpaceshipModule):
	_selectedModules.erase(module)

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
	FlightViewRef.displayAvailableModules(availableModules)
