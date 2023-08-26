extends MultiMeshInstance2D

## The main class of the plugin, it is a multimesh that uses a spritesheet to animate. 
class_name AnimatedMultiMesh

##The speed of the animation
@export var animationSpeed:float = 0.75

@export_category("Spritesheet Settings")
##the horizontal rows in the spritesheet
@export var rowsInSheet = 1
##the vertical columns in the spritesheet
@export var columnsInSheet = 1

@export_category("Spawn Automatically")
##If spawning is allowed
@export var spawn:bool = true
##The speed that instances spawn in complex mode
@export var spawnSpeed: float = 1.0
##The position of the spawn, CHANGE this over time for movement
@export var spawnPosition:Vector2

@onready var multi = get_multimesh()

##The index that will be used to spawn a multimesh instance
var currentIdx = 0

##The var that acts as a timer for spawning instances
var spawnTimer = 0.0

##Used to set the required initial values at runtime
func _setup():
	var count = multi.instance_count
	multi.instance_count = 0
	multi.use_custom_data = true
	multi.instance_count = count

func _process(delta):
	animate(delta)
	check_for_spawn(delta)

##This is CRUCIAL to the plugin. You MUST have the shader.
func _set_shader(obj:Object):
	obj.set_material(ShaderMaterial.new())
	var shader = obj.get_material()
	shader.set_shader(preload("res://addons/AnimatedMultiMesh/MultiMeshAnimation.gdshader"))
	shader.set_shader_parameter("col", float(columnsInSheet))
	shader.set_shader_parameter("row", float(rowsInSheet))

#What the custom data is used for: Color(empty, offsetx, offsety, currentTime)
func animate(delta):
	for num in multi.get_instance_count():
		var data:Color = multi.get_instance_custom_data(num)
		if data.r != 1.0:
			break
		if (data.a >= animationSpeed):
			data.a = 0
			#Checks if there is more to go in the row, and if there is not, move down a column, and if neither, reset to the origional values
			if data.g + 1.0 < rowsInSheet:
				data.g += 1.0
			else:
				if data.b + 1.0 < columnsInSheet:
					data.b += 1.0
				else:
					data.g = 0.0
					data.b = 0.0
		data.a += delta
		multi.set_instance_custom_data(num, data)

##Spawns a instance of the multimesh in a cetrain position
func spawn_instance(pos:Vector2):
	multi.set_instance_transform_2d(currentIdx, Transform2D(deg_to_rad(180), pos))
	multi.set_instance_custom_data(currentIdx, Color(1.0,0.0,0.0,0.0))
	currentIdx += 1

##Checks to see if the time is up on the spawnTimer, and if it is, spawn an instance
func check_for_spawn(delta:float):
	spawnTimer += delta
	if spawnTimer > spawnSpeed:
		spawn_instance(spawnPosition)
		spawnTimer = 0.0
