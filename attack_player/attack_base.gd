extends Node2D
class_name attack_base

var chance_crit : int
var damage_crit : int
var damage : int
var speed : int

var name_of_obj = "attack_base"
var direction

func _ready():
	chance_crit = DictionaryStats.weapons[name_of_obj]["chance_crit"]
	damage_crit = DictionaryStats.weapons[name_of_obj]["damage_crit"]
	damage = DictionaryStats.weapons[name_of_obj]["damage"]
	speed = DictionaryStats.weapons[name_of_obj]["speed"]
	set_unaction()

func set_unaction():
	visible = false
	position = Vector2(-15000,-15000)
	set_physics_process(false)

func set_action(x : Vector2):
	visible = true
	position = get_node("../../").position + Vector2(100 * x.x,100 * x.y)
	set_direction(x)
	set_physics_process(true)
	await get_tree().create_timer(2.0).timeout
	set_unaction()

func set_direction(x : Vector2):
	direction = x
	rotation = direction.angle()

func _physics_process(delta):
	position += speed * direction * delta

