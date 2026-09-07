class_name ShootingStar extends Shooter

@onready var firing_up: Firing = $FiringUp
@onready var firing_up_right: Firing = $FiringUpRight
@onready var firing_down_right: Firing = $FiringDownRight
@onready var firing_down: Firing = $FiringDown

func _ready() -> void:
	super()
	
	firing_node.fired.connect(_coordinate_fire)
	firing_up.fired.connect(_coordinate_fire)
	firing_up_right.fired.connect(_coordinate_fire)
	firing_down_right.fired.connect(_coordinate_fire)
	firing_down.fired.connect(_coordinate_fire)

func _coordinate_fire() -> void:
	firing_node.fire(false, false)
	firing_up.fire(false, false)
	firing_up_right.fire(false, false)
	firing_down_right.fire(false, false)
	firing_down.fire(false, false)
