class_name Cargo

var name: String
var length: int
var width: int
var mass: int

var id: int
var order_id: int

func _init(
	p_name: String,
	p_length: int,
	p_width: int,
	p_mass: int
) -> void:
	self.name = p_name
	self.length = p_length
	self.width = p_width
	self.mass = p_mass
	
static func addCargo(orderId, cargoList: Array[Cargo]):
	for cargo in cargoList:
		var cargo_dict = {
			"name": cargo.name,
			"length": cargo.length,
			"width": cargo.width,
			"mass": cargo.mass,
			"order_id": orderId
		}

		Database.db.insert_row("cargo", cargo_dict)

static func fetchOrderCargo(order_id: int):
	var output = Database.db.select_rows("cargo", "order_id = '%s'" % [order_id], ["id", "name", "length", "width", "mass"])
	var cargo: Array[Cargo] = []
	for row in output:
		print(row)
		var item = new(row.name, row.length, row.width, row.mass)
		item.id = row.id
		cargo.append(item)
	return cargo
