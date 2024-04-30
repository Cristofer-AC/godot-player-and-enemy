extends CharacterBody2D

const SPEED = 30000
@onready var sprite_2d = $Sprite2D

# For now the idle_animation is set
# as the character moves.
var idle_animation = ""

func move_character(delta):
	var direction = Input.get_vector("ui_left", "ui_right",  "ui_up", "ui_down")
	velocity = direction * SPEED * delta
	move_and_slide()

func play_walking_animations():	
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

func play_idle_animations():
	# Play the proper idle_animation
	if abs(velocity.x) == 0 and abs(velocity.y) == 0:
		if idle_animation != "":
			sprite_2d.animation = idle_animation

func _physics_process(delta):
	# Movement manager
	move_character(delta)
	# Walking and idle animations managers
	play_walking_animations()
	play_idle_animations()
	
