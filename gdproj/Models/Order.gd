class_name Order

var id: int
var price: float
var order_status: int

var cargo: Array[Cargo] = []

func _init(
	p_id: int,
	p_price: float,
	p_status: int
) -> void:
	id = p_id
	price = p_price
	order_status = p_status

static func fetchOrder(order_id: int) -> Order:
	var output = Database.db.select_rows("orders", "id = '%s'" % [order_id], ["id", "price", "order_status"])
	var orderData = output[0]
	return new(orderData.id, orderData.price if orderData.price else 0, orderData.order_status)

static func updateOrderPrice(order_id: int, calculated_order_cost: float):
	Database.db.update_rows("orders", "id = '%s'" % [order_id], {"price": calculated_order_cost})
	return calculated_order_cost

static func updateOrder():
	pass

static func fetchAllOrders():
	pass

static func cancelOrder():
	pass

static func addOrder(userId):
	var order_dict = {
		"order_status": 1,
		"user_id": userId
	}
	Database.db.insert_row("orders", order_dict)
	return Database.db.last_insert_rowid;
	

static func fetchAllOrderedOrders():
	pass

static func fetchUserOrders(user: User) -> Array[Order]:
	var output = Database.db.select_rows("orders", "user_id = %s" % user.id, ["id", "price", "order_status"])
	var orders: Array[Order] = []
	for row in output:
		orders.append(new(row.id, row.price if row.price else 0, row.order_status))
	return orders

static func updateOrderStatus():
	pass
