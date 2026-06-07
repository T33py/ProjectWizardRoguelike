extends Node2D
class_name Wizard

@export var state: State

var current_movespeed = 100

@onready var controller: WizardController = $Controller

func _ready() -> void:
	controller.state = state
	return
