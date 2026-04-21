class_name Database

static var db : SQLite
# good intro to the plugin
# https://www.youtube.com/watch?v=j-BRiTrw_F0
static func init():
	db = SQLite.new()
	db.path="res://data.db"
	db.open_db()
	_setup_database()
	pass

static func _setup_database() -> void:
	db.create_table("order_states", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("order_states", {"id": 1, "value":"ordered"})
	db.insert_row("order_states", {"id": 2, "value":"approved"})
	db.insert_row("order_states", {"id": 3, "value":"paid_for"})
	db.insert_row("order_states", {"id": 4, "value":"finished"})
	db.insert_row("order_states", {"id": 5, "value":"cancelled"})

	db.create_table("module_abilities", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("module_abilities", {"id": 1, "value":"temperature_shield"})
	db.insert_row("module_abilities", {"id": 2, "value":"shield"})
	db.insert_row("module_abilities", {"id": 3, "value":"extra_fuel"})
	db.insert_row("module_abilities", {"id": 4, "value":"extra_speed"})
	
	db.create_table("user_roles", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("user_roles", {"id": 1, "value":"client"})
	db.insert_row("user_roles", {"id": 2, "value":"flight_coordinator"})
	db.insert_row("user_roles", {"id": 3, "value":"administrator"})

	db.create_table("spaceship_categories", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("spaceship_categories", {"id": 1, "value":"S"})
	db.insert_row("spaceship_categories", {"id": 2, "value":"A"})
	db.insert_row("spaceship_categories", {"id": 3, "value":"B"})
	db.insert_row("spaceship_categories", {"id": 4, "value":"C"})
	db.insert_row("spaceship_categories", {"id": 5, "value":"D"})

	db.create_table("pilots", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text", "not_null": true},
		"surname": {"data_type": "text", "not_null": true},
		"license_category_id": {"data_type": "int"},
		"hourly_wage": {"data_type": "real"}
	})
	
	db.create_table("users", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"username": {"data_type": "text", "not_null": true},
		"password": {"data_type": "text"},
		"email": {"data_type": "text"},
		"user_role_id": {"data_type": "int"}
	})
	
	db.insert_row("users", {"id": 1, 
		"username":"test_admin", 
		"password": "abc", 
		"email": "a@a.com",
		"user_role_id": 1
	})
	
	db.create_table("orders", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"price": {"data_type": "real"},
		"order_status_id": {"data_type": "int"}
	
		#departure planet id
		#arrival planet id
	})
	
	db.create_table("cargo", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"length": {"data_type": "real"},
		"width": {"data_type": "real"},
		"mass": {"data_type": "real"},
		
		"order_id":{"data_type": "int"},
	})
	
	db.create_table("spaceships", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"code": {"data_type": "text"},
		"name": {"data_type": "text"},
		"speed": {"data_type": "real"},
		"max_temperature": {"data_type": "real"},
		"baggage_length": {"data_type": "real"},
		"baggage_width": {"data_type": "real"},
		"spaceship_category_id": {"data_type": "int"},
		"fuel_capacity": {"data_type": "real"},
		"fuel_usage": {"data_type": "real"},
		"module_capacity": {"data_type": "int"},
	
		"hangar_id":{"data_type": "int"},
	})
	
	db.create_table("spaceship_modules", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"module_ability_id": {"data_type": "int"},
		
		"hangar_id":{"data_type": "int"},
		"spaceship_id":{"data_type": "int"},
	})
	
	db.create_table("journeys", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"departure_date": {"data_type": "text"},
		"arrival_date": {"data_type": "text"},
		"distance": {"data_type": "real"},
		"required_fuel_amount": {"data_type": "real"},
	
		"spaceship_id":{"data_type": "int"},
		"pilot_id":{"data_type": "int"},
		"flight_coordinator_id":{"data_type": "int"}
	})
	
	db.create_table("hangars", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"spaceship_capacity": {"data_type": "int"},
		"module_capacity": {"data_type": "int"}
	
		#planet id turi ig
	})
	
	# nzn ar daryt viena entele ar kelias
	#db.create_table("celestial_objects",
		#{}
	#)
	#db.create_table("planets",
		#{}
	#)
	#db.create_table("stars",
		#{}
	#)
	
	pass
