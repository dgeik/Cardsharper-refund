extends Node2D

var can_move : bool = false
var speed : int = 550
var direction
var angle = deg_to_rad(0.15)

func _physics_process(delta):
	if can_move == true:
		position += speed * direction * delta
		rotation = angle
		angle += 0.15
