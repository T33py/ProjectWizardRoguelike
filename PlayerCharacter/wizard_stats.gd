extends Node
class_name WizardStats

signal reached_0_health()

@export var max_health: float = 10
@export var health_regen: float = 0
var _current_health: float = 10
var current_health: float:
	get: return _current_health
	set(val):
		_current_health = val
		if _current_health > max_health:
			_current_health = max_health
		if _current_health <= 0:
			reached_0_health.emit()

@export var max_mana: float = 10
@export var mana_regen: float = 0.25
var _current_mana: float = 10
var current_mana: float:
	get: return _current_mana
	set(val):
		_current_mana = val
		if _current_mana > max_mana:
			_current_mana = max_mana

@export var max_movespeed: float = 100
@export var min_movespeed: float = 25
var _current_movespeed: float = 100
var current_movespeed: float:
	get: return _current_movespeed
	set(val):
		_current_movespeed = val
		if _current_movespeed > max_movespeed:
			_current_movespeed = max_movespeed
		elif _current_movespeed < min_movespeed:
			_current_movespeed = min_movespeed

@export var max_shield: float = 10
var current_shield: float = 0

func _process(delta: float) -> void:
	current_health += health_regen
	current_mana += mana_regen
	return
