extends Position2D

var Velocidad = Vector2()
export (float) var GRAVEDAD = 100

func _ready():
	pass

func _physics_process(delta):
	
	Velocidad.y += GRAVEDAD * delta
	
	var movimiento = Velocidad * delta
	get_node("cuerpo_j1").move_and_slide(movimiento)
