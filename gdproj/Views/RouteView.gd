extends MarginContainer
class_name RouteView

func submitEndDate(panel: DatePickerPanel, date):
	$VBoxContainer/SaveRouteButton.disabled = true
	var isValid = _flightController.validateEndDate(date)
	if !isValid:
		$VBoxContainer/VBoxContainer/error.text = "Išvykimo data negali būti ši diena arba anksčiau."
		$VBoxContainer/FindRouteButton.disabled = true
		
		return
	$VBoxContainer/VBoxContainer/error.text = ""
	$VBoxContainer/FindRouteButton.text = "Rasti maršrutą"
	unlockFindRouteButton()
	
func unlockFindRouteButton():
	$VBoxContainer/FindRouteButton.disabled = false
	pass
	
func openRouteView():
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.visible = false
	visible = true

func findNextRoute():
	var result = _flightController.findRoute()
	if result is not Trip:
		$VBoxContainer/error.text = "Nepavyko rasti išvykimo laiko"
		return
	$VBoxContainer/FindRouteButton.text = "Rasti kitą maršrutą"
	foundTrip = result
	var dict = result.departureTime
	print(dict)
	$VBoxContainer/HBoxContainer/DepartDate.text = str(dict)
	$VBoxContainer/SaveRouteButton.disabled = false
	pass

var foundTrip: Trip

func displayWarning(message):
	_toast.show_message(message)
	pass

func addWarning(message):
	displayWarning(message)
	pass

func saveRoute():
	_flightController.saveCurrentRoute(foundTrip)
	pass

func _back():
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.visible = true
	visible = false
