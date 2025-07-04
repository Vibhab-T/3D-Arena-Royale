extends Node3D
@onready var timer: Timer = $Timer
@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel


var player_score = 0
var time_left = 10
var timer_started = false

func _physics_process(delta: float) -> void:
	if(time_left > 0 and timer_started):
		time_left -= 1 * delta 
		time_label.text = "Time left: " + str(int(time_left)) + "s"

func increase_score():
	player_score += 1
	score_label.text = "Score: " + str(player_score)
	if (player_score == 1):
		timer.start()
		timer_started = true


func _on_spawner_mob_spawned(mob: Variant) -> void:
	mob.mob_death.connect(increase_score)


func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()


func _on_timer_timeout() -> void:
	time_label.text = "Time Over. Reloading scene"
	
	Engine.set_time_scale(0.25)
	
	get_tree().reload_current_scene.call_deferred()
