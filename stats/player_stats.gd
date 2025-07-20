extends Node

var weapons := [attack_base.new()]
var weapon
var weapon_scene

func _ready():
	weapon = weapons.back()
	weapon_scene = load("res://attack_player/" + weapon.name_of_obj + ".tscn")
