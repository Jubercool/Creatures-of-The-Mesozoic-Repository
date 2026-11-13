extends Node2D
var enemyscene = preload("res://Scenes/enemy.tscn")
#ischigualastia, herrerasaurus, saurosuchus, eoraptor
var enemy_amounts = [40, 60, 20, 100]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for enemy_type in range(4):
		for enemy in range(enemy_amounts[enemy_type]):
			var spawned_enemy = enemyscene.instantiate()
			spawned_enemy.global_position = Vector2i(randi_range(7500,93000),randi_range(-5500,61000))
			spawned_enemy.type = Global.dinopedia[enemy_type]["name"]
			spawned_enemy.add_to_group("enemies")
			add_child(spawned_enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
