extends KinematicBody2D

var Velocidad = Vector2()
export (float) var GRAVEDAD = 100
export (float) var VEL_MOVIMIENTO = 25
export (float) var VEL_SALTO = 25
enum estados {corriendo, saltando, cayendo}
var estado_actual = estados.cayendo

func _ready():
	get_node("AnimationPlayer").play("Enem_run")

func _physics_process(delta):
	Velocidad.y += GRAVEDAD * delta
	
	if(!get_node("Sprite").flip_h):
		Velocidad.x = -VEL_MOVIMIENTO
	else:
		Velocidad.x = VEL_MOVIMIENTO
	
	var movimiento = Velocidad * delta
	move_and_slide(movimiento)
	
	if(!test_move(transform, Vector2(0,1)) && estado_actual != estados.cayendo && estado_actual != estados.saltando):
		if(rand_range(0,10) < 5):
			estado_actual = estados.saltando
			get_node("AnimationPlayer").play("Enem_jump")
			Velocidad.y -= VEL_SALTO
		else:
			estado_actual = estados.cayendo
			get_node("Sprite").flip_h = !get_node("Sprite").flip_h
			if(Velocidad.x > 0):
				global_position.x -= 10
			else:
				global_position.x += 10
			Velocidad.x = 0
			global_position.y -= 70
	
	if(get_slide_collision(get_slide_count() - 1) != null):
		var obj_collision = get_slide_collision(get_slide_count() - 1).collider
		if(obj_collision.is_in_group("suelo") && estado_actual != estados.corriendo):
			estado_actual = estados.corriendo
	
	


