extends CharacterBody2D

const SPEED = 30000
@onready var sprite_2d = $Sprite2D

# For now the idle_animation is set
# as the character moves.
var idle_animation = ""
var current_direction = ""

var direction_vector = Vector2.ZERO

var canAttack = true


func play_walking_animation():	
	# Diagonal movements will end in either left or right
	# walking animation.
	# Play the proper walking animation
	# and prepare the proper idle animation.
	if velocity.x > 0:
		sprite_2d.play("walking_right")
		idle_animation = "idle_right"
	elif velocity.x < 0:
		idle_animation = "idle_left"
		sprite_2d.play("walking_left")
	elif velocity.y > 0:
		idle_animation = "idle_front"
		sprite_2d.play("walking_front")
	elif velocity.y < 0:
		idle_animation = "idle_back"
		sprite_2d.play("walking_back")
		
	#direction_vector = Vector2(direction_vector.x, -1)

func move_character(delta):
	var direction = Input.get_vector("ui_left", "ui_right",  "ui_up", "ui_down")
	velocity = direction * SPEED * delta
	move_and_slide()

func play_idle_animations():
	# Play the proper idle_animation	
	sprite_2d.animation = idle_animation

func update_direction_vector():
	# Sets what direction does 
	# the player move
	
	# Refresh
	direction_vector = Vector2.ZERO
	
	# X Axis
	if velocity.x > 0:
		# Right
		direction_vector = Vector2(1, direction_vector.y)
	elif velocity.x < 0:
		# Left
		direction_vector = Vector2(-1, direction_vector.y)

	# Y Axis
	if velocity.y > 0:
		# Right
		direction_vector = Vector2(direction_vector.x, 1)
	elif velocity.y < 0:
		# Left
		direction_vector = Vector2(direction_vector.x, -1)

func update_attack_area_rotation():
	# Rotate Marker2d depending on
	# the 8 directions
	
	if direction_vector == Vector2(0, -1):
		# Up
		$AttackAreaPivot.rotation_degrees = 180
	elif direction_vector == Vector2(1, -1):
		# Up right
		$AttackAreaPivot.rotation_degrees = -135
	elif direction_vector == Vector2(1, 0):
		# Right
		$AttackAreaPivot.rotation_degrees = -90
	elif direction_vector == Vector2(1, 1):
		# Down right
		$AttackAreaPivot.rotation_degrees = -45
	elif direction_vector == Vector2(0, 1):
		# Down
		$AttackAreaPivot.rotation_degrees = 0
	elif direction_vector == Vector2(-1, 1):
		# Down left
		$AttackAreaPivot.rotation_degrees = 45
	elif direction_vector == Vector2(-1, 0):
		# Left
		$AttackAreaPivot.rotation_degrees = 90
	elif direction_vector == Vector2(-1, -1):
		# Up left
		$AttackAreaPivot.rotation_degrees = 135

func attack():
	print("Attacking")

	# Here CollisionShape will detect enemies
	$AttackAreaPivot/AttackArea/CollisionShape2D.disabled = false
	canAttack = false

	# Attack duration starts
	$AttackDuration.start()

func _physics_process(delta):
	# Move character
	move_character(delta)
	# Play the proper animation
	play_walking_animation()
	
	# If idle
	if abs(velocity.x) == 0 and abs(velocity.y) == 0:
		if idle_animation != "":
			direction_vector = Vector2.ZERO
			play_idle_animations()
	
	# Control attack area orientation
	update_direction_vector()
	update_attack_area_rotation()
	
	# Attack
	if Input.is_action_pressed("ui_accept"):
		if canAttack:
			attack()

func _on_attack_area_body_entered(body):
	# Detect enemy
	print("Body entered in attack area")

func _on_attack_reload_time_timeout():
	# When refreshing time ends
	# Prepare everything for a new attack
	canAttack = true

func _on_attack_duration_timeout():
	# Start refreshing time
	$AttackReloadTime.start()
	# Disable CollisionShape
	$AttackAreaPivot/AttackArea/CollisionShape2D.disabled = true
