extends TextureRect

var snapx
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	snapx = global_position.x+85
	updateChildren()

var debugDrawQueue = []
func _draw():
	for i in debugDrawQueue:
		draw_circle(i-position,50,Color(0,255,255))
	debugDrawQueue.clear()

func updateChildren():
	for i in range(get_child_count()):
		if get_child(i).position.distance_to(-((i+1) * Vector2(0,-80))) > 10:
			get_child(i).position = lerp(get_child(i).position, -((i+1) * Vector2(0,-80)),0.5)

func getIntendedPosition(idx):
	return -((idx+1) * Vector2(0,-80))


func checkSnap(posy,snapDistance):
	debugDrawQueue.append(global_position)
	if abs(global_position.y -posy) < snapDistance/2:
		return true
	elif abs(global_position.y -posy) < snapDistance*2 and get_child_count()==0:
		return true
	for i in range(get_child_count()):
		debugDrawQueue.append(get_child(i).global_position)
		if abs(get_child(i).global_position.y -posy) < snapDistance/2:
			return true
		elif i == get_child_count()-1 and abs(get_child(i).global_position.y -posy) < snapDistance*2:
			return true
	return false


func getSnap(posy,snapDistance):
	if abs(global_position.y -posy) < snapDistance/2:
		return 0
	elif abs(global_position.y -posy) < snapDistance*2 and get_child_count()==0:
		return 0
	for i in range(get_child_count()):
		if abs(getIntendedPosition(i).y -posy) < snapDistance/2:
			return i
		elif i == get_child_count()-1 and abs(getIntendedPosition(i).y -posy) < snapDistance*2:
			return i
	return false


func checkRemove(pos,snapDistance):
	if abs(pos.x-snapx) > snapDistance:
		return true
	if abs(global_position.y -pos.y) < snapDistance/2:
		return false
	elif abs(global_position.y -pos.y) < snapDistance*2 and get_child_count()-1==0:
		return false
	for i in range(get_child_count()):
		if abs(getIntendedPosition(i).y -pos.y) < snapDistance/2:
			return false
		elif i == get_child_count()-1 and abs(getIntendedPosition(i).y -pos.y) < snapDistance*2:
			return false
	return true
