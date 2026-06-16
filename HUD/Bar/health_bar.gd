extends Control
class_name HealthBar

@onready var progress_bar: TextureProgressBar = $TextureProgressBar

func update_bar(stats: WizardStats) -> void:
	progress_bar.max_value = stats.max_health
	progress_bar.value = stats.current_health
	return
