extends Control

#func _ready() -> void:
	#Database.init()
	#var data = Database.db.select_rows("orders", "", ["*"])
	#print(data)

func _exit_tree() -> void:
	Database.db.close_db()


func _on_cancel_pressed() -> void:
	pass # Replace with function body.
