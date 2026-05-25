extends MarginContainer
class_name CalcCostsView

func openFlightCostView() -> void:
	$MarginContainer/MainLayout/FlightView/GenerateRoute.visible = false
	$MarginContainer/MainLayout/FlightView/CalcOrderCosts.visible = true
	
func _on_CalculateButton_pressed() -> void:
	var price_per_kg = $VBoxContainer/PricePerKg/PricePerKgInput.text.to_float()
	var price_per_sqm = $VBoxContainer/PricePerSqm/PricePerSqmInput.text.to_float()
	var markup_percent = $VBoxContainer/Markup/MarkupInput.text.to_float()

	var result = null
	if _flightController:
		result = _flightController.calculateTotalCosts(price_per_kg, price_per_sqm, markup_percent)

	if result == null:
		$VBoxContainer/Error.text = "Invalid input"
		$VBoxContainer/Result.text = ""
		return

	$VBoxContainer/Error.text = ""
	$VBoxContainer/Result.text = "Profit: " + str(result)
