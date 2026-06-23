class_name HitSponge extends Plant

@onready var health_doll: HealthDoll = $HealthDoll

func _ready():
	super()
	health_doll.update_health(health / max_health)

func take_damage(damage: float):
	super(damage)
	health_doll.update_health(health / max_health)
