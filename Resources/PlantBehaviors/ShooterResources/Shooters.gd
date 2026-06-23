class_name Shooters extends PlantBehaviorResource

## How many bullets are fired per shot
@export_range(1, 100, 1) var bullets_per_fire: int = 1
## Amount of seconds between each shot.
@export_range(0.05, 60) var fire_delay: float = 1
@export var projectile: Projectiles
@export var projectile_scene: PackedScene = load("res://Code/Projectile.tscn")
@export_range(1, 10, 1) var detection_range: int = 9
@export var fire_sound: AudioStream
