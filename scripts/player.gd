extends CharacterBody2D


@export var speed : float = 225.0
@export var jump_force : float = -150.0
@export var jump_time : float = 0.25
@export var coyote_time : float = 0.075
@export var gravity_multiplier: float = 3.0

var is_jumping : bool = false
var jump_timer : float = 0
var coyote_timer : float = 0

@onready var PlayerAnimation: AnimatedSprite2D = $PlayerAnimation
@onready var EmoteAnimation: AnimatedSprite2D = $EmoteAnimation

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_jumping:
		velocity += get_gravity() * gravity_multiplier * delta
		coyote_timer += delta
	else:
		coyote_timer = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer < coyote_time):
		velocity.y = jump_force
		is_jumping = true
	elif Input.is_action_pressed("jump") and is_jumping:
		velocity.y = jump_force
		
	if is_jumping and Input.is_action_pressed("jump") and jump_timer < jump_time:
		jump_timer += delta
	else:
		is_jumping = false
		jump_timer = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

# Flip the sprite to face direction moving in
	if direction != 0:
		PlayerAnimation.flip_h = direction < 0
	
# Animations
	if not is_on_floor():
		PlayerAnimation.play("Jump")
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		PlayerAnimation.play("Walk")
	else:
		PlayerAnimation.stop()
	
	move_and_slide()

# Trigger for the Cat Emote
func _on_cat_trigger_body_entered(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("Angry")

func _on_cat_trigger_body_exited(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("None")

# Trigger for the Carrot Emote
func _on_carrot_trigger_body_entered(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("Happy")

func _on_carrot_trigger_body_exited(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("None")

# Trigger for Ball Emote
func _on_tennis_ball_trigger_body_entered(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("Excited")

func _on_tennis_ball_trigger_body_exited(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("None")

# Trigger for Storm Emote
func _on_storm_trigger_body_entered(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("Scared")

func _on_storm_trigger_body_exited(_body: CharacterBody2D) -> void:
	EmoteAnimation.play("None")

# Trigger Slow Down
func _on_slow_trigger_body_entered(_body: CharacterBody2D) -> void:
	speed = 100
	jump_force = -75
