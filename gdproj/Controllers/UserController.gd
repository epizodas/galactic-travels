extends Node
class_name UserController

func openLoginPage():
	var LoginViewRef = get_tree().current_scene.find_child("LoginView") as LoginView
	LoginViewRef.displayLoginPage()
	pass

func validate():
	var user = User.fetchUser("test_admin")
	print(user.username)
	pass
