class_name Plant extends Node2D

var health: float = 5
var max_health: float = health
var cost: int = 100
var _name: String = "Plant"
var plant_cooldown: float= 1

@export var plant_data: PlantData

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

signal plant_died(position: Vector2)

func _ready():
	initialize()

func initialize():
	_name = plant_data.name
	health = plant_data.max_health
	max_health = health
	cost = plant_data.cost
	plant_cooldown = plant_data.plant_cooldown
	animated_sprite.sprite_frames = plant_data.sprite_frames

func take_damage(damage: float) -> void:
	health -= damage

func _process(_delta):
	if health <= 0:
		_die()

func _die():
	plant_died.emit(global_position)
	queue_free()
