extends Node3D
@onready var marker_3d: Marker3D = $Marker3D
@onready var timer: Timer = $Timer

@export var Mob_To_Spawn: PackedScene = null

func _on_timer_timeout() -> void:
	var new_mob = Mob_To_Spawn.instantiate()
	add_child(new_mob)
	new_mob.global_position = marker_3d.global_position
