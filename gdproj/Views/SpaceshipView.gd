extends MarginContainer
class_name SpaceshipView

@onready var table: Tree = $VBoxContainer/Tree 

func _ready():
	setup_table_columns()

func setup_table_columns():
	table.columns = 9
	table.column_titles_visible = true
	table.hide_root = true
	table.select_mode = Tree.SELECT_ROW
	
	table.set_column_title(0, "Name")
	table.set_column_title(1, "Code")
	table.set_column_title(2, "Speed")
	table.set_column_title(3, "Max t.")
	table.set_column_title(4, "Cargo(LxW)")
	table.set_column_title(5, "Cat.")
	table.set_column_title(6, "Fuel cap.")
	table.set_column_title(7, "Fuel con.")
	table.set_column_title(8, "Module cap.")

func displaySpaceshipPage():
	var _mainView = get_tree().current_scene.find_child("MainView", true, false) as Control
	if _mainView: _mainView.visible = false
	self.visible = true

func openSpaceshipTable(spaceships: Array[Spaceship]):
	table.clear()
	var root = table.create_item()
	table.hide_root = true
	
	for ship in spaceships:
		var row = table.create_item(root)
		row.set_text(0, ship.name)
		row.set_text(1, ship.code)
		row.set_text(2, str(ship.speed) + "m/s")
		row.set_text(3, str(ship.maxTemp) + "K")
		row.set_text(4, str(ship.cargoLength) + "x" + str(ship.cargoWidth))
		row.set_text(5, ship.category)
		row.set_text(6, str(ship.fuelCapacity) + "L")
		row.set_text(6, str(ship.fuelConsumption) + "L/km")
		row.set_text(6, str(ship.moduleCapacity))
		
		row.set_metadata(0, ship.shipId)
