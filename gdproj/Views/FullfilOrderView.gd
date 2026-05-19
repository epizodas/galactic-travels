extends MarginContainer
class_name FullfilOrderView

func displayFullfilOrderModal():
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	_mainView.visible = false
	self.visible = true
	pass
	
func submit():
	var cost_1kg = $VBoxContainer/Cost1kgInput/LineEdit.number
	var cost_1m2 = $VBoxContainer/Cost1m2Input/LineEdit.number
	var profit_margin = $VBoxContainer/ProfitMarginInput/LineEdit.number
	var errMsg = _flightController.validate(cost_1kg, cost_1m2, profit_margin)
	if errMsg != "":
		$VBoxContainer/Error.text = errMsg
	pass
