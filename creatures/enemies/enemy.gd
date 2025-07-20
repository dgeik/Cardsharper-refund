extends Node2D

var hp = 10
var damage = 0
var name_of_obj
var timer_to_attack = 3.0
var speed := 350

func _ready():
	#hp = DictionaryStats.enemies[name_of_obj]["hp"]
	#damage = DictionaryStats.enemies[name_of_obj]["damage"]
	phase1()

func phase1():
	pass

func phase2():
	pass

func take_damage(body):
	hp -= body.damage
	body.set_unaction()
	if hp <= 0:
		print("death")

func give_damage(body):
	body.hp -= damage

func _on_hitbox_bullets_body_entered(body):
	take_damage(body)

func _on_hitbox_player_body_entered(body):
	give_damage(body)
