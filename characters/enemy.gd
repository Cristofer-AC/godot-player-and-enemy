extends CharacterBody2D


@onready var player = get_node("/root/Main/Player")

const SPEED = 150

func _physics_process(delta):
	var direciton = global_position.direction_to(player.global_position)
	velocity = direciton * SPEED
	move_and_slide()
