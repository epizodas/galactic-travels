extends MarginContainer
class_name CalcCostsView

func openFlightCostView() -> void:
	$MarginContainer/MainLayout/FlightView/GenerateRoute.visible = false
	$MarginContainer/MainLayout/FlightView/CalcOrderCosts.visible = true
