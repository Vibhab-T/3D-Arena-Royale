extends Node3D
@onready var score_label: Label = $Label

var player_score = 0

func increase_score():
	player_score += 1
	score_label.text = "Score: " + str(player_score)


func _on_spawner_mob_spawned(mob: Variant) -> void:
	mob.mob_death.connect(increase_score)


func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
