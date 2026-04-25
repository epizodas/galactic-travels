class_name Spaceship

enum Category {S, A, B, C, D}

var name: String
var code: String
var speed: float
var maxTemp: float
var cargoLength: int
var cargoWidth: int
var category: Category
var fuelCapacity: float
var fuelConsumption: float
var moduleCapacity: int

func _init(
	p_name: String,
	p_code: String,
	p_speed: float,
	p_maxTemp: float,
	p_cargoLength: int,
	p_cargoWidth: int,
	p_category: Category,
	p_fuelCapacity: float,
	p_fuelConsumption: float,
	p_moduleCapacity: int,
) -> void:
	name = p_name
	code = p_code
	speed = p_speed
	maxTemp = p_maxTemp
	cargoLength = p_cargoLength
	cargoWidth = p_cargoWidth
	category = p_category
	fuelCapacity = p_fuelCapacity
	fuelConsumption = p_fuelConsumption
	moduleCapacity = p_moduleCapacity

static func fetchAllSpaceships() -> Array[Spaceship]:
	var output = Database.db.select_rows(
		"spaceship",
		"",
		["name", "code", "speed", "maxTemp", "cargoLength", "cargoWidth", "category", "fuelCapacity", "fuelConsumption", "moduleCapacity"])
	
	var retval: Array[Spaceship] = []
	for spaceshipData in output:
		retval.push_back(new(
			spaceshipData.name,
			spaceshipData.code,
			spaceshipData.speed,
			spaceshipData.maxTemp,
			spaceshipData.cargoLength,
			spaceshipData.cargoWidth,
			spaceshipData.category,
			spaceshipData.fuelCapacity,
			spaceshipData.fuelConsumption,
			spaceshipData.moduleCapacity
	))

	return retval

static func getSpaceship(ship_code: String) -> Spaceship:
	var output = Database.db.select_rows(
		"spaceship",
		"code = '%s'" % [ship_code],
		["name", "code", "speed", "maxTemp", "cargoLength", "cargoWidth", "category", "fuelCapacity", "fuelConsumption", "moduleCapacity"])
	
	var spaceshipData = output[0]
	return new(
		spaceshipData.name,
		spaceshipData.code,
		spaceshipData.speed,
		spaceshipData.maxTemp,
		spaceshipData.cargoLength,
		spaceshipData.cargoWidth,
		spaceshipData.category,
		spaceshipData.fuelCapacity,
		spaceshipData.fuelConsumption,
		spaceshipData.moduleCapacity
	)

static func updateSpaceship(ship: Spaceship):
	var ship_dict = {
		"name": ship.name,
		"code": ship.code,
		"speed": ship.speed,
		"maxTemp": ship.maxTemp,
		"cargoLength": ship.cargoLength,
		"cargoWidth": ship.cargoWidth,
		"category": ship.category,
		"fuelCapacity": ship.fuelCapacity,
		"fuelConsumption": ship.fuelConsumption,
		"moduleCapacity": ship.moduleCapacity
	}
	
	Database.db.update_rows("spaceship", "code = '%s'" % [ship.code], ship_dict)
	pass # TODO
	
static func addSpaceship(ship: Spaceship):
	var ship_dict = {
		"name": ship.name,
		"code": ship.code,
		"speed": ship.speed,
		"maxTemp": ship.maxTemp,
		"cargoLength": ship.cargoLength,
		"cargoWidth": ship.cargoWidth,
		"category": ship.category,
		"fuelCapacity": ship.fuelCapacity,
		"fuelConsumption": ship.fuelConsumption,
		"moduleCapacity": ship.moduleCapacity
	}
	Database.db.insert_row("spaceship", ship_dict)
	pass

static func deleteSpaceship(ship_code: String):
	Database.db.delete_rows("spaceship", "code = '%s'" % [ship_code])
