class_name DiggingFen extends Enemy

enum STATUS {
	## We are digging towards the left side of the map
	DIGGING,
	## We are playing the emerging animation
	EMERGING,
	## We are playing the rotating animation
	ROTATING,
	## We are delaying movement a little bit
	WAITING,
	## We are moving towards the right side of the map
	MOVING
}

var digging: bool = true
var rotation_count: int = 0
var state: STATUS = STATUS.DIGGING

@onready var dirt_particles: GPUParticles2D = $DirtParticles
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var emerge_timer: Timer = $EmergeTimer

func _ready() -> void:
	speed = 35
	animated_sprite.set_animation("digging")
	detection_ray.set_enabled(false)
	dirt_particles.set_emitting(true)

func _physics_process(delta: float) -> void:
	if position.x <= 128 and digging:
		speed = 0
		digging = false
		_play_emerging_animation()
		return

	super(delta)

func _enable_hitbox() -> void:
	has_entered_board = true

func _play_emerging_animation():
	animated_sprite.play("emerging")
	state = STATUS.EMERGING

func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		STATUS.EMERGING:
			state = STATUS.ROTATING
			dirt_particles.set_emitting(false)
			animated_sprite.play("rotate")
			rotation_count += 1
			hitbox_shape.set_disabled(false)
		STATUS.ROTATING:
			var play_in_reverse: bool = rotation_count % 2 == 1
			if play_in_reverse:
				animated_sprite.play_backwards("rotate")
			else:
				animated_sprite.play("rotate")
			rotation_count += 1
			if rotation_count > 3:
				state = STATUS.WAITING
				animated_sprite.set_animation("moving")
				emerge_timer.start()

func _on_emerge_timer_timeout() -> void:
	speed = -25
	detection_ray.set_enabled(true)
