extends MarginContainer
class_name MainView

@onready var accDropdown: PopupMenu = $VBoxContainer/Navbar/UserAccountDropdown.get_popup()

func _ready() -> void:
	accDropdown.id_pressed.connect(_handleAccountDropdown)
	$VBoxContainer/Navbar/UserAccountDropdown.disabled = true

func openUserDropdown():
	var user = _userController.getCurrentUser()
	accDropdown.clear()
	accDropdown.add_item(user.username, 0)
	accDropdown.set_item_disabled(0, true)
	accDropdown.add_item("Atsijungti", 1)
	pass

func _handleAccountDropdown(id: int):
	match id:
		1:
			_userController.logout()
	pass

func openLoginPage() -> void:
	_userController.openLoginPage()

func displayMainPage() -> void:
	var LoginViewRef = get_tree().current_scene.find_child("LoginView") as LoginView
	LoginViewRef.visible = false
	self.visible = true
	for child in $VBoxContainer/Placeholder.get_children() as Array[Control]:
		child.visible = false
	if _userController.loggedInUser:
		$VBoxContainer/LoginBar.visible = false
		var roleName = ""
		match _userController.loggedInUser.role:
			1:
				roleName = "Klientas"
			2:
				roleName = "Skrydžio koordinatorius"
				$VBoxContainer/Placeholder/CoordinatorView.visible = true
			3:
				roleName = "Administratorius"
		$VBoxContainer/Navbar/UserAccountDropdown.text = roleName
		$VBoxContainer/Navbar/UserAccountDropdown.disabled = false
	else:
		$VBoxContainer/LoginBar.visible = true
		$VBoxContainer/Navbar/UserAccountDropdown.text = "Svečias"
		$VBoxContainer/Navbar/UserAccountDropdown.disabled = true
		
	pass
