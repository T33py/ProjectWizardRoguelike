extends Control
class_name HUD

@export var state:State
@export var wizard: Wizard

@onready var healthbar: HealthBar = $HealthBar
@onready var manabar: ManaBar = $ManaBar
@onready var skill1: SkillSquare = $SkillSquare1

func _ready() -> void:
	wizard.stats.health_changed.connect(_on_wizard_health_changed)
	wizard.stats.mana_changed.connect(_on_wizard_mana_changed)
	skill1.assign_skill($SkillSquare1/Projectile)
	return

func _on_wizard_health_changed() -> void:
	healthbar.update_bar(wizard.stats)
	return

func _on_wizard_mana_changed() -> void:
	manabar.update_bar(wizard.stats)
	return
