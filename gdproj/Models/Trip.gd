class_name Trip

var id: int
var departureTime: Dictionary
var arrivalTime: Dictionary
var distance: float
var requiredFuel: float

var spaceship = Spaceship.new(
	"Shipas",
	"SPH-132",
	100,
	1000,
	50,
	80,
	Spaceship.Category.A,
	5000,
	20,
	10
)

var intersectPlanet = false


func _init(
	p_departureTime: Dictionary,
	p_arrivalTime: Dictionary,
	p_distance: float,
	p_requiredFuel: float
) -> void:
	var departureTime = p_departureTime
	var arrivalTime = p_arrivalTime
	var distance = p_distance
	var requiredFuel = p_requiredFuel
	
	#spaceship.modules = [
		#SpaceshipModule.new("Kuro bakas", SpaceshipModule.Type.Fuel)
	#]
	
static func fetchTrips() -> Array[Trip]:
	var output = Database.db.select_rows("trip", "", ["id", "departureTime", "arrivalTime", "distance", "requiredFuel"])
	var trips: Array[Trip] = []
	for row in output:
		#print(row)
		var deptTime = Time.get_datetime_dict_from_datetime_string(row.departureTime, false)
		var arrvTime = Time.get_datetime_dict_from_datetime_string(row.arrivalTime, false)
		var item = new(deptTime, arrvTime, row.distance, row.requiredFuel)
		item.id = row.id
		trips.append(item)
	return trips
