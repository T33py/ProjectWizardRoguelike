@tool
extends TextureButton
class_name SquareButton

var _text: String = 'Template Text'
@export_multiline var text: String :
	get: return _text
	set(val):
		_text = val
		if label != null:
			update_text() 
var _style: String = '[b][color=black]'
@export var style: String:
	get: return _style
	set(val):
		_style = val
		if label != null:
			update_text()

@onready var label: RichTextLabel = $RichTextLabel
@onready var click_player: AudioStreamPlayer = $ClickPlayer

func _ready() -> void:
	update_text()
	pressed.connect(_on_pressed)
	pass

func update_text() -> void:
	label.text = _style + _text
	pass

func _on_pressed() -> void:
	click_player.play()
	return
