extends Node
class_name State

enum WizardActivities { IDLE, PAUSED, DEAD, CASTING, PLACING_BUILDING }
enum PlayerActivities { MENUING, WIZARDING, MESSING_WITH_BUILDING }

signal wizard_changed_activity(to: WizardActivities)
signal player_changed_activity(to: PlayerActivities)

@export var game_runner: GameRunner
@export var hex_map: HexMap

var _current_wizard_activity: WizardActivities = WizardActivities.CASTING
var current_wizard_activity: WizardActivities:
	get: return _current_wizard_activity
	set(val):
		_current_wizard_activity = val
		wizard_changed_activity.emit(val)

var _current_player_activity: PlayerActivities = PlayerActivities.WIZARDING
var current_player_activity: PlayerActivities:
	get: return _current_player_activity
	set(val):
		_current_player_activity = val
		wizard_changed_activity.emit(val)
