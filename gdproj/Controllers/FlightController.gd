extends Node
class_name FlightController

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
