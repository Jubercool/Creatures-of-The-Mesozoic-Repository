extends Node2D
var enemyscene = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemy1 = enemyscene.instantiate()
	enemy1.position=Vector2i(1000,0)
	add_child(enemy1)
	var enemy2 = enemyscene.instantiate()
	enemy2.position=Vector2i(1000,1000)
	add_child(enemy2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
