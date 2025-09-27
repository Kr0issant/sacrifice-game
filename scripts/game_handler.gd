extends Node2D

enum CURRENT_PLAYER { ALERTER, OFFICER, SCIENTIST, MAYOR, ENGINEER, MEDIC }

const mission_locations = {
	"find_mayor": Vector2(2180, 630)
}

@onready var dialogic = get_node("/root/Dialogic")

signal mission_active(is_mission_right_now, mission_desc)
var mission_desc = "find_mayor"
var mission_status = false:
	set(val):
		mission_active.emit(val, mission_locations[mission_desc])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stage1.tscn")
