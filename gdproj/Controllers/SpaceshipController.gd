extends Node
class_name SpaceshipController

@export var view: SpaceshipView

func _ready():
	showSpaceships()

func showSpaceships():
	var spaceship_list: Array[Spaceship] = Spaceship.getAll()
	view.displaySpaceshipPage()
	view.openSpaceshipTable(spaceship_list)

func validateSpaceship():
	pass

func errorMessage(msg: String):
	print("Error: ", msg)
