extends Control
class_name SkillComponent

@export var display_name: String = ''

@export_category('Cooldown reduction')
@export var cdr: float = 0
@export var triggered_cdr: float = 0
@export var on_kill_cdr: bool = false
@export var on_build_cdr: bool = false
@export var on_cast_cdr: bool = false
