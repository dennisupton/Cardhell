extends VBoxContainer

@export var cardLerpWeight = 0.5
var holding = null
var snapDistance = 100
var setMouse
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("editCards"):
		$"../..".visible = not $"../..".visible
		get_tree().paused = $"../..".visible
	
	
	#contoller support
	var direction = Input.get_vector("aimLeft", "aimRight", "aimUp", "aimDown")
	if $"../..".visible:
		if abs(direction.x) + abs(direction.y) >0 :
			Input.warp_mouse(get_window().get_mouse_position()+direction*10)
			print(round(direction))
		if Input.is_action_just_pressed("triggerShoot"):
			var event := InputEventMouseButton.new()
			event.button_index = MouseButton.MOUSE_BUTTON_LEFT
			event.pressed = true
			event.position = get_viewport().get_mouse_position()
			Input.parse_input_event(event)
			setMouse = true
		if setMouse and not Input.is_action_just_pressed("triggerShoot"):
			setMouse = false
			var event := InputEventMouseButton.new()
			event.button_index = MouseButton.MOUSE_BUTTON_LEFT
			event.pressed = false
			event.position = get_viewport().get_mouse_position()
			Input.parse_input_event(event)
	if holding:
		$"../../Line2D".position.x = $"../../OnEnemy".snapx
		if abs(get_global_mouse_position().x-$"../../OnShoot".snapx) <= snapDistance and $"../../OnShoot".checkSnap(get_global_mouse_position().y,snapDistance):
			if not holding in $"../../OnShoot".get_children():
				holding.get_parent().remove_child(holding)
				holding.scale = Vector2(1,1)
				$"../../OnShoot".add_child(holding)
				$"../../OnShoot".updateChildren()
			$"../../OnShoot".move_child(holding,$"../../OnShoot".getSnap(get_global_mouse_position().y,snapDistance))
		elif abs(get_global_mouse_position().x-$"../../OnEnemy".snapx) <= snapDistance and $"../../OnEnemy".checkSnap(get_global_mouse_position().y,snapDistance):
			if not holding in $"../../OnEnemy".get_children():
				print("adding card to on enemy")
				holding.get_parent().remove_child(holding)
				holding.scale = Vector2(1,1)
				$"../../OnEnemy".add_child(holding)
				$"../../OnEnemy".updateChildren()
			$"../../OnEnemy".move_child(holding,$"../../OnEnemy".getSnap(get_global_mouse_position().y,snapDistance))
		elif not holding in $"../../".get_children() and holding.get_parent().checkRemove(get_global_mouse_position(),snapDistance):
			holding.global_position = lerp(holding.global_position, get_global_mouse_position()+Vector2(-50,-50), cardLerpWeight )
			if not holding in $"../../".get_children():
				print("witholding card")
				var oldPos = holding.global_position
				holding.get_parent().remove_child(holding)
				$"../..".add_child(holding)
				holding.scale = Vector2(0.7,0.7)
				holding.global_position = oldPos
				holding.global_position = lerp(holding.global_position, get_global_mouse_position()+Vector2(-50,-50), cardLerpWeight )
		elif holding in $"../../".get_children():
			holding.global_position = lerp(holding.global_position, get_global_mouse_position()+Vector2(-50,-50), cardLerpWeight )

	if !Input.is_action_pressed("Shoot"):
		if holding and holding in $"../../".get_children():
			print("put back")
			$"../..".remove_child(holding)
			add_child(holding)
			holding.position = Vector2(0,0)
		holding = null






func _on__button_down(source: BaseButton) -> void:
	if holding == null:
		source.get_parent().remove_child(source)
		$"../..".add_child(source)
		source.scale = Vector2(0.7,0.7)
		holding = source
		holding.global_position = get_global_mouse_position()+Vector2(-50,-50)
