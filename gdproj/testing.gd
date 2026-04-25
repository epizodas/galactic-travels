extends Control

#func _ready() -> void:
	#Database.init()
	#var data = Database.db.select_rows("orders", "", ["*"])
	#print(data)

func _exit_tree() -> void:
	Database.db.close_db()
