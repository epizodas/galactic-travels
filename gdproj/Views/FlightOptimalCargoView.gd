extends Node
class_name FlightOptimalCargoView

func displayFlightOptimalCargoView():
	var flight_view = get_tree().current_scene.find_child("FlightView", true, false)
	if flight_view:
		flight_view.visible = false
	self.visible = true

func pressCalculateButton():
	_flightController.calculateOptimalCargo();
	pass
