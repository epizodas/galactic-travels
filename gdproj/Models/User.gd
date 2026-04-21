class_name User

var username: String
var email: String
var password: String
var role: int

func _init(username: String, email: String, password: String, role: int) -> void:
	self.username = username
	self.email = email
	self.password = password
	self.role = role
	pass

static func fetchUser(username: String) -> User:
	var output = Database.db.select_rows("users", "username = '%s'" % [username], ["id", "password", "email", "user_role_id"])
	var userData = output[0]
	var user = new(username, userData.email, userData.password, userData.user_role_id)
	return user
