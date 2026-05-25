class_name Pilot

var name: String
var surname: String
var category: int
var hourly_wage: float

func _init(name: String, surname: String, category: int, hourly_wage: float) -> void:
	self.name = name
	self.surname = surname
	self.category = category
	self.hourly_wage = hourly_wage
	pass

static func fetchPilot(id: int):
	var output = Database.db.select_rows("pilots", "id = %d" % [id], ["id", "name", "surname", "spaceship_category_id", "hourly_wage"])
	var pilotData = output[0]
	return new(pilotData.name, pilotData.surname, pilotData.spaceship_category_id, pilotData.hourly_wage)
	pass

static func fetchPilots() -> Array[Pilot]:
	var output = Database.db.select_rows("pilots", "", ["id", "name", "surname", "spaceship_category_id", "hourly_wage"])
	var retval: Array[Pilot] = []
	for pilotData in output:
		retval.push_back(new(pilotData.name, pilotData.surname, pilotData.spaceship_category_id, pilotData.hourly_wage))
	return retval
