extends Panel

var close_timer = 0.1
var close_cooldown = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	close_timer += delta
	if close_timer >= close_cooldown:
		close_timer = close_cooldown
	$CloseButton.modulate = Color(close_timer/close_cooldown, close_timer/close_cooldown, close_timer/close_cooldown)

func _on_close_button_pressed() -> void:
	if close_timer >= close_cooldown:
		visible = false
		Creaturestats.running = true
