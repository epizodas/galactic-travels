class_name User

var id: int
var username: String
var email: String
var password: String
var role: int

func _init(username: String, email: String, password: String, role: int) -> void:
	self.username = username
	self.email = email
	self.password = password
	self.role = role
	self.id = 0
	pass

static func fetchUser(username: String):
	var output = Database.db.select_rows("users", "username = '%s'" % [username], ["id", "username", "password", "email", "user_role_id"])
	var userData = output[0]
	var user = new(userData.username, userData.email, userData.password, userData.user_role_id)
	user.id = userData.id
	return user

static func fetchUsers() -> Array[User]:
	var output = Database.db.select_rows("users", "", ["id", "username", "password", "email", "user_role_id"])
	var retval: Array[User] = []
	for userData in output:
		retval.push_back(new(userData.username, userData.email, userData.password, userData.user_role_id))
	return retval
