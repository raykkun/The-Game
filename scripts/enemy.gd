extends CharacterBody2D

@export var speed: float = 50
var player: CharacterBody2D = null

func _ready():
	var players = get_tree().get_nodes_in_group("PlayerGroup")
	if players.size() > 0:
		player = players[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity.x = direction.x * speed 
		#velocity.y = 0
		move_and_slide()
	
	
