extends SpaceBody
class_name Planet

var atmHeight: float
var atmDensity: float

func _init(
	p_name: String,
	p_mass: float,
	p_temp: float,
	p_radius: float,
	p_color: String,
	p_orbitXOffset: float,
	p_orbitYOffset: float,
	p_orbitalPeriod: float,
	p_orbitalRadius: float,
	p_phase: float,
	p_atmHeight: float,
	p_atmDensity: float
) -> void:
	super._init(
		p_name, 
		p_mass, 
		p_temp, 
		p_radius, 
		p_color, 
		p_orbitXOffset, 
		p_orbitYOffset, 
		p_orbitalPeriod, 
		p_orbitalRadius, 
		p_phase
	)
	atmHeight = p_atmHeight
	atmDensity = p_atmDensity
	
static func fetchAllPlanets():
	var output = Database.db.select_rows(
	"planets",
	"",
	["id", "spaceBody_id", "hangar_id", "atmHeight", "atmDensity"])
	
	var retval: Array[Planet] = []
	for pd in output:
		var sb = Database.db.select_rows("spacebodies", "id = '%s'" % [pd.spaceBody_id], 
			["id", "name", "mass", "temp", "radius", "color", 
			"orbitXOffset", "orbitYOffset", "orbitalPeriod", "orbitalRadius", "phase"])
		if(len(sb) == 0):
			continue
		sb = sb[0]
		retval.push_back(new(sb.name, sb.mass, sb.temp, sb.radius, sb.color, 
			sb.orbitXOffset, sb.orbitYOffset, sb.orbitalPeriod, sb.orbitalRadius, sb.phase, pd.atmHeight, pd.atmDensity))

	return retval
