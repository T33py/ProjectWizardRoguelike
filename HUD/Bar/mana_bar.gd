extends Control
class_name ManaBar

@onready var progress_bar: TextureProgressBar = $TextureProgressBar

func update_bar(stats: WizardStats) -> void:
	progress_bar.max_value = stats.max_mana
	progress_bar.value = stats.current_mana
	return
