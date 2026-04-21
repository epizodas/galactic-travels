extends MarginContainer
class_name LoginView

func displayLoginPage():
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	_mainView.visible = false
	self.visible = true
	pass
	
func submit():
	_userController.validate()
	pass
