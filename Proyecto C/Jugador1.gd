extends Position2D

var Velocidad = Vector2()
export (float) var GRAVEDAD = 100
export (float) var VEL_MOVIMIENTO = 25
export (float) var VEL_SALTO = 25
var puede_saltar = false

func _ready():
	pass

func _physics_process(delta):
	
	Velocidad.y += GRAVEDAD * delta
	
	if(Input.is_action_pressed("tecla_a")):
		Velocidad.x = -VEL_MOVIMIENTO
		get_node("cuerpo_j1/Sprite_J1").flip_h = false
		if(Input.is_action_pressed("tecla_w")):
			get_node("animacion_J1").play("J1_diagArriba")
		elif(Input.is_action_pressed("tecla_s")):	
			get_node("animacion_J1").play("J1_diagAbajo")
		elif(Input.is_action_just_released("tecla_w") || Input.is_action_just_released("tecla_s")):
			get_node("animacion_J1").stop()
		elif(!get_node("animacion_J1").is_playing()):
			get_node("animacion_J1").play("J1_corriendo")
		
			
	elif(Input.is_action_pressed("tecla_d")):
		Velocidad.x = VEL_MOVIMIENTO
		get_node("cuerpo_j1/Sprite_J1").flip_h = true
		if(Input.is_action_pressed("tecla_w")):
			get_node("animacion_J1").play("J1_diagArriba")
		elif(Input.is_action_pressed("tecla_s")):	
			get_node("animacion_J1").play("J1_diagAbajo")
		elif(Input.is_action_just_released("tecla_w") || Input.is_action_just_released("tecla_s")):
			get_node("animacion_J1").stop()
		elif(!get_node("animacion_J1").is_playing()):
			get_node("animacion_J1").play("J1_corriendo")
		
	elif(Input.is_action_pressed("tecla_w")):
		get_node("animacion_J1").play("J1_haciaArriba")
	elif(Input.is_action_pressed("tecla_s")):
		get_node("animacion_J1").play("J1_cuerpotierra")
	else:
		Velocidad.x = 0
		if(puede_saltar):
			get_node("animacion_J1").play("J1_idle")
	
	if(Input.is_action_pressed("tecla_espacio") && puede_saltar):
		Velocidad.y = -VEL_SALTO
		get_node("animacion_J1").play("J1_salto")
		puede_saltar = false
	
	var movimiento = Velocidad * delta
	get_node("cuerpo_j1").move_and_slide(movimiento)
	
	if(get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1) != null):
		var obj_colisionado = get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1).collider
		if(obj_colisionado.is_in_group("suelo")):
			if(puede_saltar == false):
				puede_saltar = true
				get_node("animacion_J1").stop()
			


