extends Node
class_name UserController

var loggedInUser: User = null

func logout():
	loggedInUser = null
	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.displayMainPage()
	pass

func getCurrentUser() -> User:
	var user = User.fetchUser(loggedInUser.username)
	return user

func openLoginPage():
	var LoginViewRef = get_tree().current_scene.find_child("LoginView") as LoginView
	LoginViewRef.displayLoginPage()
	pass

func validateUser(users: Array[User], username: String, password: String) -> User:
	for user in users:
		if user.username == username and user.password == password:
			return user
	return null

func login(user: User):
	if user:
		var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
		loggedInUser = user
		MainViewRef.displayMainPage()

func validate(username, password) -> String:
	var users = User.fetchUsers()
	print(users)
	var user = validateUser(users, username, password)
	if user:
		login(user)
		return ""
	return "User does not exist"
