extends StaticBody2D


var speed = 200
var bulletWait = 800
var startHealth = 60
var health

var random = RandomNumberGenerator.new()
var lastBulletTime = Time.get_ticks_msec()+random.randi_range(200,5000)
var damageText
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damageText = $Info/Damage
	health = startHealth
	$Info/health.max_value = startHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Info.global_position = global_position
	$Info/health.value = health
	look_at($"../../Player".position)
	#position += Vector2(cos(rotation),sin(rotation))
	var velocity = Vector2(cos(rotation),sin(rotation))*speed
	move_and_collide(velocity * _delta)

	if Time.get_ticks_msec()-lastBulletTime > bulletWait:
		lastBulletTime = Time.get_ticks_msec()+random.randi_range(200,500)
		var child = $"../../Player".bullet.instantiate()
		
		var predictedPosition = 15*($"../../Player".position-$"../../Player".lastPosition) + $"../../Player".position
		child.rotation = position.angle_to_point(predictedPosition)
		child.position = position
		child.target = "player"
		child.startingSpeed = 10
		$"../..".add_child(child)
func dealDamage(dam):
	health -= dam
	if damageText.visible:
		damageText.text = str(int(damageText.text)+dam)
		damageText.get_child(0).play("hit")
	else:
		damageText.text = str(dam)
		damageText.get_child(0).play("hit")
	if health-10 < 0:
		queue_free()
