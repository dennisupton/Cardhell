extends Sprite2D

var onShoot = []
var onEnemy = []
var effects = []
var startingSpeed
var speed = startingSpeed
var timeBetweenEffects = 500

var lastEffect = 0
var strength = 1.0
var currenteffect = 0
var nearest = false
var alrHit = []
var collidingWithEnemy = false

var target
func _ready() -> void:
	texture = texture.duplicate(true)
	effects = onShoot
	if startingSpeed == null:
		startingSpeed = 25
	speed = startingSpeed
	if target == "player":
		texture.gradient.set_color(0,Color(255,0,0))
	else:
		texture.gradient.set_color(0,Color(0,0,255))

func findNearest():
	nearest = false
	var Ndistance = 100000
	for i in get_tree().get_nodes_in_group("Enemy"):
		if position.distance_to(i.position)< Ndistance and not i in alrHit:
			Ndistance = position.distance_to(i.position)
			nearest = i
	return nearest


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Time.get_ticks_msec()-lastEffect > timeBetweenEffects and len(effects) != 0:
		#print(effects)
		lastEffect = Time.get_ticks_msec()
		if currenteffect == 3:
			queue_free()
			return
		currenteffect = 0
		speed = startingSpeed
		if int(effects[0]) == 1:
			#print("split")
			strength = strength /3
			var child1 = $"../Player".bullet.instantiate()
			var child2 = $"../Player".bullet.instantiate()
			child1.position = position
			child2.position = position
			child1.rotation = rotation
			child2.rotation = rotation
			child1.rotate(0.5)
			child2.rotate(-0.5)
			child1.strength = strength
			child2.strength = strength
			var effects2 = effects.duplicate() 
			effects2.pop_front()
			child1.effects = effects2
			child2.effects = effects2
			child1.lastEffect = Time.get_ticks_msec()
			child2.lastEffect = Time.get_ticks_msec()
			$"../".add_child(child1)
			$"../".add_child(child2)
		elif int(effects[0]) == 2:
			currenteffect = 2
			nearest = findNearest()
			#look_at(findNearest().global_position)
		elif int(effects[0]) == 3:
			currenteffect = 3
		elif int(effects[0]) == 4:
			currenteffect = 4
		effects.pop_front()
		
		

	elif Time.get_ticks_msec()-lastEffect > timeBetweenEffects:
		lastEffect = Time.get_ticks_msec()
		currenteffect = 0
	if currenteffect == 2:
		if nearest:
			rotation =lerp_angle(rotation,(nearest.position - global_position).angle(),0.05) 
	elif currenteffect == 3:
		scale += Vector2(2,2)
	elif currenteffect == 4 and not collidingWithEnemy:
		lastEffect = 0
	if not currenteffect == 3:
		position += Vector2(cos(rotation),sin(rotation))*speed
	collidingWithEnemy = false
	for i in $Area2D.get_overlapping_bodies():	
		if i.is_in_group("Enemy") and target == "enemy":
			collidingWithEnemy = true
			if not i in alrHit:
				alrHit.append(i)
				i.dealDamage(10)
			if len(onEnemy)>0 and int(onEnemy[0] ) == 4:
				effects = onEnemy
			else:
				queue_free()
		if i.is_in_group("Player") and target == "player":
			collidingWithEnemy = true
			if not i in alrHit:
				alrHit.append(i)
				i.dealDamage(10)
			if len(onEnemy)>0 and int(onEnemy[0] ) == 4:
				effects = onEnemy
			else:
				queue_free()
	if position.distance_to($"../Player".position)> 10000:
		queue_free()
