extends Node

var weapons := {}
var enemies := {}

func _ready():
	weapons = LoadFromJson.load_json("res://stats/weapon_stats.json")
	enemies = LoadFromJson.load_json("res://stats/enemies_stats.json")
