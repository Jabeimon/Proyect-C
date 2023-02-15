extends KinematicBody2D

var Velocidad = Vector2()
export var potencia = 0

func _ready():
	Velocidad.x = 0
	Velocidad.y = 0
	var todos_suelos = get_tree().get_nodes_in_group("suelo")
	for suelo in todos_suelos:
		add_collision_exception_with(suelo)

func _physics_process(delta):
	var movimiento = Velocidad * delta
	move_and_slide(movimiento)



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
