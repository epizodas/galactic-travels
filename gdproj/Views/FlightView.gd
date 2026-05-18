extends MarginContainer
class_name FlightView

func displayFlightView():
	self.visible = true

func submitPlanets():
	_flightController.submitPlanets()

func changeSpaceshipModules() -> void:
	_flightController.changeSpaceshipModules()

func displayAvailableModules(modules: Array[SpaceshipModule]):
	pass
