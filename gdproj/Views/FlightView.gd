extends MarginContainer
class_name FlightView

func displayFlightView():
	self.visible = true

func submitPlanets():
	_flightController.submitPlanets()
