extends CharacterBody2D

var direction
var speed := 250

func _physics_process(delta):
	direction = Vector2(Input.get_axis("ui_left","ui_right"),
	Input.get_axis("ui_up","ui_down")).normalized()
	velocity = direction * speed
	move_and_slide()
