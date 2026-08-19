extends Node2D
var enemyscene = preload("res://Scenes/enemy.tscn")

var enemies = [
	#position, type
	[Vector2i(1000,0),"eoraptor"],
	#[Vector2i(1000,1000),"ischigualastia"],
	#[Vector2i(0,1000),"ischigualastia"],
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for enemy in enemies:
		var spawned_enemy = enemyscene.instantiate()
		spawned_enemy.position = enemy[0]
		spawned_enemy.type = enemy[1]
		spawned_enemy.add_to_group("enemies")
		add_child(spawned_enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
