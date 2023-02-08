extends Position2D

var Velocidad = Vector2()
export (float) var GRAVEDAD = 100
export (float) var VEL_MOVIMIENTO = 25
export (float) var VEL_SALTO = 25
var puede_saltar = false
var esta_en_agua = false
enum estados {idle, cuerpo_tierra, sumergido}
var estado_actual = estados.idle
export(PackedScene) var bala_comun
export(Vector2) var spawnB_izq
export(Vector2) var spawnB_arr
export(Vector2) var spawnB_izqAR
export(Vector2) var spawnB_izqAB

func _ready():
	spawnB_izq = get_node("cuerpo_j1/SpawnBala").position

func _physics_process(delta):
	
	Velocidad.y += GRAVEDAD * delta
	
	if(Input.is_action_pressed("tecla_a") && estado_actual != estados.cuerpo_tierra && estado_actual != estados.sumergido):
		Velocidad.x = -VEL_MOVIMIENTO
		get_node("cuerpo_j1/SpawnBala").position = spawnB_izq
		get_node("cuerpo_j1/Sprite_J1").flip_h = false
		if(Input.is_action_pressed("tecla_w") && (puede_saltar) && !esta_en_agua):
			get_node("animacion_J1").play("J1_diagArriba")
			get_node("cuerpo_j1/SpawnBala").position = spawnB_izqAR
		elif(Input.is_action_pressed("tecla_s") && (puede_saltar) && !esta_en_agua):	
			get_node("animacion_J1").play("J1_diagAbajo")
			get_node("cuerpo_j1/SpawnBala").position = spawnB_izqAB
		elif(Input.is_action_just_released("tecla_w") && (puede_saltar) && !esta_en_agua || Input.is_action_just_released("tecla_s") && (puede_saltar) && !esta_en_agua):
			get_node("animacion_J1").stop()
		elif(!get_node("animacion_J1").is_playing() && (puede_saltar)):
			if(!esta_en_agua):
				get_node("animacion_J1").play("J1_corriendo")
			else:
				get_node("animacion_J1").play("J1_nadando")
			
	elif(Input.is_action_pressed("tecla_d") && estado_actual != estados.cuerpo_tierra && estado_actual != estados.sumergido):
		Velocidad.x = VEL_MOVIMIENTO
		get_node("cuerpo_j1/SpawnBala").position = Vector2(spawnB_izq.x * -1, spawnB_izq.y)
		get_node("cuerpo_j1/Sprite_J1").flip_h = true
		if(Input.is_action_pressed("tecla_w") && (puede_saltar) && !esta_en_agua):
			get_node("animacion_J1").play("J1_diagArriba")
			get_node("cuerpo_j1/SpawnBala").position = Vector2(spawnB_izqAR.x * -1, spawnB_izqAR.y)
		elif(Input.is_action_pressed("tecla_s") && (puede_saltar) && !esta_en_agua):	
			get_node("animacion_J1").play("J1_diagAbajo")
			get_node("cuerpo_j1/SpawnBala").position = Vector2(spawnB_izqAB.x * -1, spawnB_izqAB.y)
		elif(Input.is_action_just_released("tecla_w") && (puede_saltar) && !esta_en_agua|| Input.is_action_just_released("tecla_s") && (puede_saltar) && !esta_en_agua):
			get_node("animacion_J1").stop()
		elif(!get_node("animacion_J1").is_playing() && (puede_saltar)):
			if(!esta_en_agua):
				get_node("animacion_J1").play("J1_corriendo")
			else:
				get_node("animacion_J1").play("J1_nadando")
		
	elif(Input.is_action_pressed("tecla_w") && estado_actual != estados.cuerpo_tierra && estado_actual != estados.sumergido):
		if(puede_saltar && !esta_en_agua):
			get_node("animacion_J1").play("J1_haciaArriba")
			get_node("cuerpo_j1/SpawnBala").position = spawnB_arr
		Velocidad.x = 0
	elif(Input.is_action_pressed("tecla_s")):
		if(puede_saltar):
			if(!esta_en_agua):
				get_node("animacion_J1").play("J1_cuerpotierra")
				estado_actual = estados.cuerpo_tierra
			else:
				get_node("animacion_J1").play("J1_bajoagua")
		else:
			get_node("cuerpo_j1/SpawnBala").position = Vector2(spawnB_arr.x, spawnB_arr.y * -1)
		Velocidad.x = 0
	else:
		Velocidad.x = 0
		if(puede_saltar):
			if(!esta_en_agua):
				get_node("animacion_J1").play("J1_idle")
				if(estado_actual == estados.cuerpo_tierra):
					get_node("cuerpo_j1").global_position -= Vector2(0, 35)
					estado_actual = estados.idle
			else:
				get_node("animacion_J1").play("J1_agua")
	
	if(Input.is_action_pressed("tecla_espacio") && puede_saltar && estado_actual != estados.sumergido):
		if(estado_actual != estados.cuerpo_tierra):
			Velocidad.y = -VEL_SALTO
			get_node("animacion_J1").play("J1_salto")
		else:
			get_node("cuerpo_j1").global_position += Vector2(0, 5)
			estado_actual = estados.idle
			get_node("animacion_J1").play("J1_idle")
			
		puede_saltar = false
	
	if(Input.is_action_pressed("tecla_x")):
		var newBala = bala_comun.instance()
		newBala.global_position = get_node("cuerpo_j1/SpawnBala").global_position
		get_tree().get_nodes_in_group("main")[0].add_child(newBala)
	
	var movimiento = Velocidad * delta
	get_node("cuerpo_j1").move_and_slide(movimiento)
	
	if(get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1) != null):
		var obj_colisionado = get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1).collider
		if(obj_colisionado.is_in_group("suelo")):
			if(puede_saltar == false):
				puede_saltar = true
				get_node("animacion_J1").stop()
				if(obj_colisionado.is_in_group("agua")):
					esta_en_agua = true
				else:
					esta_en_agua = false 
	elif(puede_saltar):
		puede_saltar = false


