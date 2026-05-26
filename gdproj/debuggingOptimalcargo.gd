# CargoDebugVisualizer.gd
# Attach to a Control node (e.g. a Panel or SubViewport)
extends Control

var _free_rects: Array = []
var _placed_items: Array = []
var _grid_w: int = 0
var _grid_h: int = 0

signal step_pressed

func _ready() -> void:
	var btn := Button.new()
	btn.text = "Next step"
	btn.pressed.connect(func(): step_pressed.emit())
	add_child(btn)

const COLORS = {
	"empty": Color(0.945, 0.937, 0.910),
	"free_fill": Color(0.753, 0.867, 0.592, 0.8),
	"free_stroke": Color(0.231, 0.427, 0.067),
	"placed_fill": Color(0.710, 0.831, 0.957, 0.85),
	"placed_stroke": Color(0.094, 0.373, 0.647),
	"grid_line": Color(0.827, 0.820, 0.792),
	"text": Color(0.173, 0.173, 0.165),
}

const PLACED_PALETTE = [
	[Color(0.710, 0.831, 0.957), Color(0.094, 0.373, 0.647)],
	[Color(0.624, 0.882, 0.796), Color(0.059, 0.431, 0.337)],
	[Color(0.961, 0.769, 0.702), Color(0.847, 0.353, 0.188)],
	[Color(0.957, 0.753, 0.820), Color(0.831, 0.325, 0.494)],
	[Color(0.753, 0.867, 0.592), Color(0.388, 0.604, 0.067)],
	[Color(0.980, 0.780, 0.459), Color(0.729, 0.459, 0.090)],
]

func update_state(grid_w: int, grid_h: int, free_rects: Array, placed_items: Array) -> void:
	_grid_w = grid_w
	_grid_h = grid_h
	_free_rects = free_rects
	_placed_items = placed_items
	queue_redraw()

func _draw() -> void:
	if _grid_w <= 0 or _grid_h <= 0:
		return

	var pad := 30.0
	var available_w := size.x - pad * 2
	var available_h := size.y - pad * 2
	var cell := minf(available_w / _grid_w, available_h / _grid_h)

	var origin := Vector2(pad, pad)

	# Empty background
	draw_rect(Rect2(origin, Vector2(cell * _grid_w, cell * _grid_h)), COLORS["empty"])

	# Grid lines
	for x in range(_grid_w + 1):
		var xp := origin.x + x * cell
		draw_line(Vector2(xp, origin.y), Vector2(xp, origin.y + _grid_h * cell), COLORS["grid_line"], 0.5)
	for y in range(_grid_h + 1):
		var yp := origin.y + y * cell
		draw_line(Vector2(origin.x, yp), Vector2(origin.x + _grid_w * cell, yp), COLORS["grid_line"], 0.5)

	# Free rectangles
	for r in _free_rects:
		var pos := origin + Vector2(r["x"] * cell, r["y"] * cell)
		var rect_size := Vector2(r["w"] * cell, r["h"] * cell)
		draw_rect(Rect2(pos + Vector2(1, 1), rect_size - Vector2(2, 2)), COLORS["free_fill"])
		draw_rect(Rect2(pos + Vector2(1, 1), rect_size - Vector2(2, 2)), COLORS["free_stroke"], false, 1.5)
		if cell > 12:
			draw_string(
				ThemeDB.fallback_font,
				pos + rect_size * 0.5 - Vector2(0, 5),
				"%dx%d" % [r["w"], r["h"]],
				HORIZONTAL_ALIGNMENT_CENTER,
				rect_size.x,
				maxi(9, int(cell * 0.35)),
				COLORS["free_stroke"]
			)

	# Placed items
	var order_color_map := {}
	var color_idx := 0
	for item in _placed_items:
		var key = item.get("label", "item")
		if not order_color_map.has(key):
			order_color_map[key] = color_idx % PLACED_PALETTE.size()
			color_idx += 1
		var ci: int = order_color_map[key]
		var fill: Color = PLACED_PALETTE[ci][0]
		var stroke: Color = PLACED_PALETTE[ci][1]

		var pos := origin + Vector2(item["x"] * cell, item["y"] * cell)
		var rect_size := Vector2(item["w"] * cell, item["h"] * cell)
		draw_rect(Rect2(pos + Vector2(2, 2), rect_size - Vector2(4, 4)), fill)
		draw_rect(Rect2(pos + Vector2(2, 2), rect_size - Vector2(4, 4)), stroke, false, 2.0)
		if cell > 10:
			draw_string(
				ThemeDB.fallback_font,
				pos + rect_size * 0.5 - Vector2(0, 4),
				str(key),
				HORIZONTAL_ALIGNMENT_CENTER,
				rect_size.x - 4,
				maxi(9, int(cell * 0.32)),
				stroke
			)

	# Axis labels
	for x in range(_grid_w):
		draw_string(ThemeDB.fallback_font, Vector2(origin.x + x * cell + cell * 0.5 - 4, origin.y - 8), str(x), HORIZONTAL_ALIGNMENT_LEFT, -1, 10, COLORS["text"])
	for y in range(_grid_h):
		draw_string(ThemeDB.fallback_font, Vector2(origin.x - 22, origin.y + y * cell + cell * 0.5 + 4), str(y), HORIZONTAL_ALIGNMENT_LEFT, -1, 10, COLORS["text"])
