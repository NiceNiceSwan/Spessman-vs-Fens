class_name Dragon extends Shooter

@onready var firing_north: Firing = $Firing/FiringNorth
@onready var firing_south: Firing = $Firing/FiringSouth

var use_northern_node: bool = true
var use_southern_node: bool = true

func _ready() -> void:
	super()
	if firing_north.global_position.y < Defines.TILE_MAP_Y_OFFSET:
		use_northern_node = false
	
	if firing_south.global_position.y >= get_viewport().get_visible_rect().size.y - Defines.TILE_MAP_Y_OFFSET:
		use_southern_node = false
	
	firing_node.fired.connect(_coordinate_fire)
	firing_north.fired.connect(_coordinate_fire)
	firing_south.fired.connect(_coordinate_fire)

func _coordinate_fire() -> void:
	firing_node.fire(false, false)
	
	if use_northern_node:
		firing_north.fire(false, false)
	
	if use_southern_node:
		firing_south.fire(false, false)
