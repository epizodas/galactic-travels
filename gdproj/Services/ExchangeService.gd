class_name ExchangeService

static func convertPrice(price: float, currency: String) -> float:
	var new_price = roundf(price * randf_range(0.1, 10.0) * 100) / 100
	return new_price
