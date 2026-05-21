extends MarginContainer
class_name RouteView

func submitEndDate(panel: DatePickerPanel, date):
	var isValid = _flightController.validateEndDate(date)
	if !isValid:
		$VBoxContainer/VBoxContainer/error.text = "Išvykimo data negali būti ši diena arba anksčiau."
		$VBoxContainer/FindRouteButton.disabled = true
		return
	$VBoxContainer/VBoxContainer/error.text = ""
	unlockFindRouteButton()
	
func unlockFindRouteButton():
	$VBoxContainer/FindRouteButton.disabled = false
	pass

func findNextRoute():
	var result = _flightController.findroute()
	if result == 0:
		$VBoxContainer/error.text = "Nepavyko rasti išvykimo laiko"
	pass

func displayWarning(message):
	_toast.show_message(message)
	pass

func addWarning(message):
	displayWarning(message)
	pass
