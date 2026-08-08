extends Node2D
var enemyscene = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemy1 = enemyscene.instantiate()
	enemy1.position=Vector2i(1000,0)
	enemy1.add_to_group("enemies")
	add_child(enemy1)
	var enemy2 = enemyscene.instantiate()
	enemy2.position=Vector2i(1000,1000)
	enemy2.add_to_group("enemies")
	add_child(enemy2)
	var enemy3 = enemyscene.instantiate()
	enemy3.position=Vector2i(0,1000)
	enemy3.add_to_group("enemies")
	add_child(enemy3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
