extends AnimatedSprite2D

var can_be_closed: bool = false

func is_within_bounds(position: Vector2) -> bool:
	if position.x < 64 or position.x > (1280 - 64):
		return false
	
	if position.y < 64 or position.y > (768 - 64):
		return false
	
	return true

func _process(delta):
	global_position = get_viewport().get_mouse_position()
	visible = true
	if not is_within_bounds(global_position):
		visible = false
	
	
	global_position.x += 64
	global_position.y += 64
	global_position.x -= (int(global_position.x) % 128)
	global_position.y -= (int(global_position.y) % 128)
	
	if Input.is_action_just_pressed("click") and can_be_closed:
		queue_free()
	
	if Input.is_action_just_pressed("alt_click"):
		queue_free()


func _on_no_click_timer_timeout():
	can_be_closed = true
