extends MarginContainer
class_name FlightView

@export var DepartureSelection: OptionButton
@export var DestinationSelection: OptionButton

func displayFlightView(planets: Array[Planet]):
	self.visible = true
	for planet in planets:
		DepartureSelection.add_item(planet.name)
		DestinationSelection.add_item(planet.name)

func submitPlanets():
	_flightController.submitPlanets()

func changeSpaceshipModules() -> void:
	_flightController.changeSpaceshipModules()

func displayAvailableModules(modules: Array[SpaceshipModule]):
	pass
