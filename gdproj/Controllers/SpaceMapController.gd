extends Node
class_name SpaceMapController

func openSpaceMapPage():
	var bodies: Array[SpaceBody] = SpaceBody.fetchAllSpaceBodies();
	createSpaceMap(bodies);
	pass

func createSpaceMap(allBodies: Array[SpaceBody]):
	var nodes: Array[Node2D] = []

	var spaceMap = get_tree().current_scene.find_child("SpaceMapView") as SpaceMapView

	# Middle of the map
	var center = get_viewport().get_visible_rect().size / 2

	for body in allBodies:
		var planet := Node2D.new()

		var sprite := ColorRect.new()
		sprite.color = Color(body.color)

		sprite.size = Vector2(body.radius * 2, body.radius * 2)

		# Center sprite on planet position
		sprite.position = Vector2(
			-body.radius,
			-body.radius
		)

		planet.add_child(sprite)

		# Position relative to screen center
		planet.position = center + Vector2(
			body.orbitXOffset,
			body.orbitYOffset
		)

		nodes.append(planet)

	spaceMap.displaySpaceMap(nodes)
	
	
func getSpaceBodyInfo():
	pass
