extends MarginContainer
class_name CalcCostsView

var _flightController: FlightController

func _ready() -> void:
	visible = false
	
	if not _flightController:
		_flightController = get_tree().current_scene.find_child("FlightController", true, false) as FlightController

	var calculate_btn = get_node_or_null("VBoxContainer/Buttons/CalculateButton")
	if calculate_btn:
		calculate_btn.pressed.connect(_on_CalculateButton_pressed)
		
	var back_btn = get_node_or_null("VBoxContainer/Buttons/BackButton")
	if back_btn:
		back_btn.pressed.connect(_on_BackButton_pressed)

func openCalcCostsView() -> void:
	var FlightViewRef = get_tree().current_scene.find_child("FlightView")
	if FlightViewRef:
		FlightViewRef.visible = false
	visible = true
	$VBoxContainer/PricePerKg/PricePerKgInput.text = ""
	$VBoxContainer/PricePerSqm/PricePerSqmInput.text = ""
	$VBoxContainer/Markup/MarkupInput.text = ""
	$VBoxContainer/Error.text = ""
	$VBoxContainer/Result.text = ""

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

func _on_BackButton_pressed() -> void:
	visible = false
	var FlightViewRef = get_tree().current_scene.find_child("FlightView")
	if FlightViewRef:
		FlightViewRef.visible = true