extends "res://creatures/enemies/enemy.gd"

var eye_obj = preload("res://physical_objects/enemies_objects/eye_object.tscn")
var eye_laser = preload("res://physical_objects/enemies_objects/eye_laser.tscn")

var is_phase1 = false
var is_phase2 = false

var DIRECTIONS = [
	Vector2.UP,                # Вверх (0, -1)
	Vector2.DOWN,              # Вниз (0, 1)
	Vector2.LEFT,              # Влево (-1, 0)
	Vector2.RIGHT,             # Вправо (1, 0)
	Vector2(-1, -1).normalized(), # Влево-вверх
	Vector2(1, -1).normalized(),  # Вправо-вверх
	Vector2(-1, 1).normalized(),  # Влево-вниз
	Vector2(1, 1).normalized(),   # Вправо-вниз
]
var rad
var degreeces := [
	180,
	0,
	90,
	-90,
	135,
	225,
	45,
	-45,
]
@onready var direction : Vector2

func _init():
	name_of_obj = "eye"

func _physics_process(delta):
	direction = DIRECTIONS[2]
	position.x += 5 * direction.x

func delete_ojb():
	for i in get_node("../enemy_attack").get_children():
		get_node("../enemy_attack").remove_child(i)
	for i in get_node("eye_attack_special").get_children():
		get_node("eye_attack_special").remove_child(i)

func phase1():
	while is_phase1:
		await get_tree().create_timer(timer_to_attack).timeout
		match_attack(randi_range(0,2))
		delete_ojb()
		if hp <= hp - (hp / 3):
			phase2()
			is_phase1 = false
			is_phase2 = true

func phase2():
	while is_phase2:
		await get_tree().create_timer(timer_to_attack).timeout
		match_attack(randi_range(0,3))
		delete_ojb()
		if hp <= 0:
			is_phase2 = false

func match_attack(x:int):
	match x:
		0: attack_special()
		1: up_eye_attack()
		2: down_eye_attack()
		3: eyestorm_attack()

func match_eye_position(x:int):
	match x:
		0: return $"../eye_obj_left"
		1: return $"../eye_obj_center"
		2: return $"../eye_obj_right"
		3: return $"../eye_obj_down_right"
		4: return $"../eye_obj_down_left"

func attack_special():
	position = get_node("../Camera").position + Vector2(0,-200)
	for dir in DIRECTIONS:
		var obj = eye_obj.instantiate()
		obj.position.x = dir.x * 150
		obj.position.y = dir.y * 150
		obj.rotation = dir.angle()
		get_node("eye_attack_special").call_deferred("add_child",obj)
	
	await get_tree().create_timer(1.5).timeout
	
	var x : int = 0
	for dir in DIRECTIONS:
		var obj = eye_laser.instantiate()
		obj.position.x = dir.x * 150
		obj.position.y = dir.y * 150
		rad = deg_to_rad(degreeces[x])
		direction = Vector2(cos(rad),sin(rad))
		obj.rotation = direction.angle()
		x += 1
		get_node("eye_attack_special").call_deferred("add_child",obj)

func up_eye_attack():
	var eye_position = match_eye_position(randi_range(0,2)).position
	var obj = eye_obj.instantiate()
	obj.position = eye_position
	obj.rotation = DIRECTIONS[1].angle()
	get_node("../").get_node("enemy_attack").call_deferred("add_child",obj)
	
	obj = eye_laser.instantiate()
	obj.position = eye_position
	rad = deg_to_rad(degreeces[1])
	direction = Vector2(cos(rad),sin(rad))
	obj.rotation = direction.angle()
	obj.scale.x = 12
	get_node("../").get_node("enemy_attack").call_deferred("add_child",obj)

func down_eye_attack():
	var eye_position = match_eye_position(randi_range(3,4)).position
	var obj = eye_obj.instantiate()
	obj.position = eye_position
	if obj.position.x > 0:
		obj.rotation = DIRECTIONS[2].angle()
	else:
		obj.rotation = DIRECTIONS[3].angle()
	get_node("../").get_node("enemy_attack").call_deferred("add_child",obj)
	
	obj = eye_laser.instantiate()
	obj.position = eye_position
	if obj.position.x > 0:
		rad = deg_to_rad(degreeces[2])
	else:
		rad = deg_to_rad(degreeces[3])
	direction = Vector2(cos(rad),sin(rad))
	obj.rotation = direction.angle()
	obj.scale.x = 3
	get_node("../").get_node("enemy_attack").call_deferred("add_child",obj)

func eyestorm_attack():
	var extents
	var global_point
	var direction : Vector2

	if randi_range(0,1) == 0:
		extents = $"../right_stars"/CollisionShape2D.shape.extents
		global_point = $"../right_stars"/CollisionShape2D.global_transform
		direction = DIRECTIONS[6]
	else:
		extents = $"../left_stars"/CollisionShape2D.shape.extents
		global_point = $"../left_stars"/CollisionShape2D.global_transform
		direction = DIRECTIONS[7]

	for i in 5:
		await get_tree().create_timer(1.5).timeout
		for x in 3:
			var obj = eye_obj.instantiate()
			obj.position = global_point * Vector2(randi_range(-extents.x,extents.x),randi_range(-extents.y,extents.y))
			obj.direction = direction
			obj.can_move = true
			get_node("../").get_node("enemy_attack").call_deferred("add_child",obj)
	await get_tree().create_timer(5.0).timeout
