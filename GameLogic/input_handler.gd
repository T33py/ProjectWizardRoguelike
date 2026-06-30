extends Node
class_name InputHandler

@export var state: State

func _input(event: InputEvent) -> void:
	if event.is_action("Action1"):
		state.hud.skill1.tracked_skill.activate()
	return
