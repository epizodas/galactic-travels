class_name Order

enum Status {
	Placed,
	Confirmed,
	Paid,
	Done,
	Canceled
}

var id: int
var price: float
var status: Status

func _init(
	p_id: int,
	p_price: float,
	p_status: Status
	,
) -> void:
	id = p_id
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
	var output = Database.db.select_rows("orders", "user_id = '%s'" % [user.id], ["id", "price", "order_status"])
	var orders: Array[Order] = []
	for row in output:
		orders.append(new(row.id, row.price if row.price else 0, Status.get(row.order_status)))
	return orders

static func updateOrderStatus():
	pass
