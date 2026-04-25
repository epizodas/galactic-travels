class_name Spaceship
var id: int
var name: String
var speed: float
var maxTemp: float
var cargoLength: int
var cargoWidth: int
var category: int #ENUM
var fuelCapacity: float
var fuelConsumption: float
var moduleCapacity: int

func _init(
	p_id: int,
	p_name: String,
	p_speed: float,
	p_maxTemp: float,
	p_cargoLength: int,
	p_cargoWidth: int,
	p_category: int,
	p_fuelCapacity: float,
	p_fuelConsumption: float,
	p_moduleCapacity: int,
) -> void:
	id = p_id
	name = p_name
	speed = p_speed
	maxTemp = p_maxTemp
	cargoLength = p_cargoLength
	cargoWidth = p_cargoWidth
	category = p_category
	fuelCapacity = p_fuelCapacity
	fuelConsumption = p_fuelConsumption
	moduleCapacity = p_moduleCapacity

static func fetchAllSpaceships() -> Array[Spaceship]:
	var output = Database.db.select_rows("spaceship", "", ["id", "name", "speed", "maxTemp",
	 "cargoLength", "cargoWidth", "category", "fuelCapacity", "fuelConsumption", "moduleCapacity"])
	var retval: Array[Spaceship] = []
	for spaceshipData in output:
		retval.push_back(new(spaceshipData.id, spaceshipData.name, spaceshipData.speed,
		 spaceshipData.maxTemp,	spaceshipData.cargoLength, spaceshipData.cargoWidth,
		 spaceshipData.category, spaceshipData.fuelCapacity, spaceshipData.fuelConsumption,
		 spaceshipData.moduleCapacity))
	return retval

static func getSpaceship(id: int) -> Spaceship:
	var output = Database.db.select_rows("spaceship", "id = %d" % [id], ["id", "name", "speed", "maxTemp",
	 "cargoLength", "cargoWidth", "category", "fuelCapacity", "fuelConsumption", "moduleCapacity"])
	var spaceshipData = output[0]
	return new(spaceshipData.id, spaceshipData.name, spaceshipData.speed,
		 spaceshipData.maxTemp,	spaceshipData.cargoLength, spaceshipData.cargoWidth,
		 spaceshipData.category, spaceshipData.fuelCapacity, spaceshipData.fuelConsumption,
		 spaceshipData.moduleCapacity)

static func updateSpaceship(ship: Spaceship):
	pass # TODO
	
static func addSpaceship(ship: Spaceship):
	pass # TODO

static func deleteSpaceship(id: int):
	Database.db.delete_rows("spaceship", "id = %d" % [id])
