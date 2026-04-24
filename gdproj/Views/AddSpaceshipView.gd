extends MarginContainer
class_name AddSpaceshipView

func displaySpaceshipPage():
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	_mainView.visible = false
	self.visible = true
	pass
	
func submit():
	var name 
	var shipId # auto increment
	var speed
	var maxTemp
	var cargoLength
	var cargoWidth
	var category 
	var fuelCapacity
	var fuelConsumption
	var moduleCapacity
	
	var username = $VBoxContainer/UsernameInput/LineEdit.text
	var password = $VBoxContainer/PasswordInput/LineEdit.text
	var errMsg = _userController.validate(username, password)
	if errMsg != "":
		$VBoxContainer/Error.text = errMsg
	pass
