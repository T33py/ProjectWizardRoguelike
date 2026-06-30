extends Control
class_name Skill

@export var cooldown: float = 0
var current_cooldown_time: float = 0
var cooldown_timer: float = 0

func _process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			cooldown_timer = 0
			current_cooldown_time = 0
	return

func activate() -> void:
	if cooldown_timer <= 0:
		current_cooldown_time = cooldown
		cooldown_timer = cooldown
	return

func apply_component(component: SkillComponent) -> void:
	return
