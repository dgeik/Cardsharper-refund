extends CharacterBody2D

var speed := 350
var gravity := 1000
var jump_force := -700

var hp = 10

var is_can_attack : bool = true
var attacks := [] #максимум в 20
var direction
var direction_attack = Vector2.ZERO
var index_attack = 0
var max_attack = 20

func _ready():
	for i in max_attack:
		attacks.append(PlayerStats.weapon_scene.instantiate())
		get_node("attacks_node").call_deferred("add_child",attacks.back())

func _physics_process(delta):
	direction = Vector2(Input.get_axis("ui_left","ui_right"),
	Input.get_axis("ui_up","ui_down")).normalized()
	
	if direction.y > 0:
		direction.y = 0
	
	if direction != Vector2.ZERO:
		velocity.x = speed * direction.x
		direction_attack = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_force
	
	if velocity.y > 0:
		gravity = 2000
	else: gravity = 1000
	velocity.y += gravity * delta
	
	move_and_slide()
	
	if direction_attack.y < 0:
		direction_attack.x = 0
	
	if direction_attack and is_can_attack and is_on_floor() and Input.is_action_pressed("ui_end"):
		is_can_attack = false
		$Timer.start()
		attacks[index_attack].set_action(direction_attack)
		index_attack += 1
		if index_attack == max_attack:
			index_attack = 0

func _on_timer_timeout():
	is_can_attack = true
