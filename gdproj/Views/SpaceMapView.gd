extends Control
class_name SpaceMapView

func displaySpaceMap(planets: Array[Node2D]):

	# Add all planets
	for planet in planets:
		add_child(planet)
		
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	if _mainView: _mainView.visible = false
	self.visible = true
	
func exitSpaceMap():
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	if _mainView: _mainView.visible = true
	self.visible = false
	pass
	
func selectPlanet():
	pass
