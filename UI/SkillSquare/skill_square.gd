extends Control
class_name SkillSquare

var tracked_skill: Skill
var _clockswipe_progress: VisualShaderNodeParameter

@onready var visual: Sprite2D = $Visual

func _ready() -> void:
	return

func _process(_delta: float) -> void:
	if tracked_skill != null:
		var cd: float = 0
		if tracked_skill.current_cooldown_time > 0:
			cd = tracked_skill.cooldown_timer / tracked_skill.current_cooldown_time
		visual.material.set_shader_parameter('progress', cd)
	return

func assign_skill(skill: Skill) -> void:
	tracked_skill = skill
	return
