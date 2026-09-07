class_name HitSponge extends Plant

@onready var health_doll: HealthDoll = $HealthDoll

func _ready() -> void:
	super()
	health_doll.update_health(health / max_health)

func take_damage(damage: float) -> void:
	super(damage)
	health_doll.update_health(health / max_health)
