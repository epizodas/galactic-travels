extends Control

func _ready() -> void:
	Database._setup_database()
	var data = Database.db.select_rows("orders", "", ["*"])
	print(data)

func _exit_tree() -> void:
	Database.db.close_db()
