extends Node2D


var waveIndex = 1
var waveHealth = 0

#enemies
var baseEnemy = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		waveHealth +=  spawnEnemy(0).startHealth
	$UI/waveProgress.max_value = waveHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UI/waveProgress.value =0
	var totalHealth = 0
	for i in $Enemies.get_children():
		totalHealth += i.health
	print(totalHealth)
	$UI/waveProgress.value = totalHealth
	if totalHealth == 0:
		waveIndex += 1
		waveHealth = 0
		$UI/wave.text = "WAVE "+str(waveIndex)
		for i in range(8):
			waveHealth +=  spawnEnemy(0).startHealth
		$UI/waveProgress.max_value = waveHealth


func spawnEnemy(type):
	var randomAngle = RandomNumberGenerator.new().randi_range(-180,180)
	var child
	if type == 0:
		child = baseEnemy.instantiate()
	child.position = $Player.position+(1000+RandomNumberGenerator.new().randi_range(-200,200))*Vector2(cos(randomAngle),sin(randomAngle))
	$Enemies.add_child(child)
	return child
