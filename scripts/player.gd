extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_dead := false

func _physics_process(delta: float) -> void:
	# when player died can't move or process input keyboard noting
	if is_dead:
		velocity += get_gravity() * delta
		move_and_slide()
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# flip horinzontal when direction have value negative or positive
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")

	move_and_slide()

# Function call on killxone script
func die(jump_force := -200):
	if is_dead:
		return
		
	is_dead = true
	velocity.x = 0
	velocity.y = jump_force
	animated_sprite.play("idle") # change if have animation death
	
	#disable collision
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
