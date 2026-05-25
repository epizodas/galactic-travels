extends Node
class_name SpaceMapController

func openSpaceMapPage():
	var bodies: Array[SpaceBody] = SpaceBody.fetchAllSpaceBodies()
	var planets: Array[Planet] = Planet.fetchAllPlanets()
	var planets_by_body_id: Dictionary = {}
	for planet in planets:
		planets_by_body_id[planet.id] = planet
	var nodes = createSpaceMap(bodies, planets_by_body_id)
	
	var SpaceMapRef = get_tree().current_scene.find_child("SpaceMapView") as SpaceMapView
	
	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.visible = false
	
	SpaceMapRef.displaySpaceMap(nodes)

func createSpaceMap(allBodies: Array[SpaceBody], planets_by_body_id: Dictionary):
	var nodes: Array[Button] = []

	for body in allBodies:
		var planet := Button.new()
		planet.text = ""
		planet.tooltip_text = body.name
		planet.focus_mode = Control.FOCUS_NONE
		planet.custom_minimum_size = Vector2(body.radius * 2, body.radius * 2)
		planet.size = Vector2(body.radius * 2, body.radius * 2)
		planet.set_meta("space_body", body)
		if planets_by_body_id.has(body.id):
			planet.set_meta("planet_data", planets_by_body_id[body.id])

		var body_color = Color.from_string(body.color, Color.WHITE)
		var normal_style := StyleBoxFlat.new()
		normal_style.bg_color = body_color
		normal_style.set_corner_radius_all(int(body.radius))
		planet.add_theme_stylebox_override("normal", normal_style)

		var hover_style := normal_style.duplicate()
		hover_style.bg_color = body_color.lightened(0.12)
		planet.add_theme_stylebox_override("hover", hover_style)
		planet.add_theme_stylebox_override("pressed", normal_style.duplicate())

		var body_ref := body
		var planet_ref: Planet = planets_by_body_id.get(body.id)
		
		if body.name != 'Sun':
			planet.pressed.connect(func():
				var SpaceMapRef = get_tree().current_scene.find_child("SpaceMapView") as SpaceMapView
				if SpaceMapRef:
					SpaceMapRef.selectPlanet(planet_ref)
			)

		nodes.append(planet)
	
	return nodes
	
func exitSpaceMap():
	var SpaceMapRef = get_tree().current_scene.find_child("SpaceMapView") as SpaceMapView
	SpaceMapRef.visible = false
	
	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.displayMainPage()
	
func getSpaceBodyInfo(planet):
	var planetData = SpaceBody.fetchSpaceBody(planet)
	return planetData
