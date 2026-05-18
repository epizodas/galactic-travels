class_name Order
var orderId: int
var price: String
var status: int

func _init(
	p_orderId: int,
	p_price: String,
	p_status: int
	,
) -> void:
	orderId = p_orderId
	price = p_price
	status = p_status

static func fetchOrder():
	
	pass

static func updateOrder():
	pass

static func fetchAllOrders():
	pass

static func cancelOrder():
	pass

static func addOrder():
	pass

static func fetchAllOrderedOrders():
	pass

static func fetchUserOrders(user: User) -> Array[Order]:
	#var output = Database.db.select_rows("orders", "code = '%s'" % [id], ["id", "name", "code", "speed", "maxTemp"])
	var orders: Array[Order] = []
	return orders

static func updateOrderStatus():
	pass
