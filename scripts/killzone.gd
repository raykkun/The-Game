extends Area2D

@onready var timer: Timer = $Timer

@export var jump_force := -200 

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		print("die")
		Engine.time_scale = 0.5
		body.die(jump_force)	
		timer.start()
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
 
