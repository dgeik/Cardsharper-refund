extends Node2D

@export var to_scene : String
var is_on_body : bool = false

func _on_body_entered(body):
	is_on_body = true
	

func _on_body_exited(body):
	is_on_body = false

func _physics_process(delta):
	if is_on_body and Input.is_action_just_pressed("ui_accept"):
		var scene = load("res://place/" + to_scene + ".tscn").instantiate()
		get_tree().root.call_deferred("add_child",scene)
		get_node("..").queue_free()
