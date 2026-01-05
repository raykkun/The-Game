extends CharacterBody2D

enum {
	PATROL,
	CHASE
}

@export var speed: float = 50

@onready var snake_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_detect: Area2D = $"../Area Detect"
@onready var area_shape: CollisionShape2D = $"../Area Detect/Area Shape"


var state = PATROL
var player: CharacterBody2D = null
var patrol_left: float
var patrol_right: float
var patrol_direction := 1

func _ready():
	var players = get_tree().get_nodes_in_group("PlayerGroup")
	if players.size() > 0:
		player = players[0]
	
	setup_patrol_range()

func setup_patrol_range():
	var shape = area_shape.shape
	if shape is RectangleShape2D:
		var widht = shape.size.x
		var center_x = area_detect.global_position.x
		patrol_left = center_x - widht / 2
		patrol_right = center_x + widht / 2
	else:
		push_error("AreaDetect must use RectangleShape2D")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		PATROL:
			patrol()
		CHASE:
			chase()
			
	move_and_slide()
	update_flip()

# STATE BEHAVIOR
func patrol():
	velocity.x = patrol_direction * speed
	velocity.y = 0
	
	if global_position.x <= patrol_left:
		patrol_direction = 1
	elif global_position.x >= patrol_right:
		patrol_direction = -1
func chase():
	if player == null:
		state = PATROL
		return
	
	var direction = global_position.direction_to(player.global_position)
	velocity.x = direction.x * speed 
	velocity.y = 0

# AREA SIGNAL
func _on_area_detect_body_entered(body: Node2D) -> void:
	if body == player:
		state = CHASE

func _on_area_detect_body_exited(body: Node2D) -> void:
	if body == player:
		state = PATROL
		velocity.x = 0
		
# FLIP
func update_flip():
	if velocity.x > 0:
		snake_sprite.flip_h = false
	elif velocity.x < 0:
		snake_sprite.flip_h = true
