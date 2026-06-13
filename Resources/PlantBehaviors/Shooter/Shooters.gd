class_name Shooters extends Resource

@export_range(1, 100, 1) var bullets_per_fire: int = 1
## Amount of times this fires per second
@export_range(0.01, 100) var fire_rate: float = 1
@export var projectile: Projectiles
@export_range(1, 10, 1) var range: int = 1
