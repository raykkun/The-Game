extends CharacterBody2D

@export var speed: float = 50
var player: CharacterBody2D = null
@onready var snake_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var players = get_tree().get_nodes_in_group("PlayerGroup")
	if players.size() > 0:
		player = players[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()
	


func _on_area_detect_body_entered(body: Node2D) -> void:
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		#print(direction)
		#if direction > 0:
			#snake_sprite.flip_h = false
		#elif direction < 0:
			#snake_sprite.flip_h = true
			
		velocity.x = direction.x * speed 
		velocity.y = 0
	
