extends StaticBody2D


@export var SPEED = 5.0

var bullet = preload("res://bullet.tscn")
@export var fireWait = 500
var lastFire = Time.get_ticks_msec()
var lastPosition

var startHealth = 200
var health


var setMouse = false
func getOnShoot():
	var eff = []
	for i in $"../UI/Cards/OnShoot".get_children():
		eff.append(i.name)
	return eff

func getOnEnemy():
	var eff = []
	for i in $"../UI/Cards/OnEnemy".get_children():
		eff.append(i.name)
	return eff


func _ready():
	health = startHealth
	$"../UI/Health".max_value = startHealth

func _process(_delta: float) -> void:
	$"../UI/Health".value = health
	
	#controller support
	var direction = Input.get_vector("aimLeft", "aimRight", "aimUp", "aimDown")
	if abs(direction.x) + abs(direction.y) >0 :
		$gun.look_at($gun.global_position+direction) 
	else:
		$gun.look_at(get_local_mouse_position()+position) 
	if Input.is_action_pressed("Shoot") and Time.get_ticks_msec()-lastFire > fireWait and not $"../UI/Cards".visible:
		lastFire = Time.get_ticks_msec()
		var child = bullet.instantiate()
		child.rotation = $gun.global_rotation
		child.position = position
		child.onShoot = getOnShoot()
		child.onEnemy = getOnEnemy()
		child.target = "enemy"
		$"..".add_child(child)

	lastPosition = position
	if Input.is_action_pressed("Up"):
		position.y -= SPEED
	elif Input.is_action_pressed("Down"):
		position.y += SPEED
	if Input.is_action_pressed("Right"):
		position.x += SPEED
	elif Input.is_action_pressed("Left"):
		position.x -= SPEED
	$"../Player/Polygon2D".position = lerp($"../Player/Polygon2D".position,20*(position-lastPosition) + position,0.3)
	
func dealDamage(dam):
	health -= dam
