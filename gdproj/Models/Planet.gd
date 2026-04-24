extends SpaceBody
class_name Planet

var atmHeight: float
var atmDensity: float

func _init(
	p_name: String,
	p_mass: float,
	p_temp: float,
	p_radius: float,
	p_color: float,
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
