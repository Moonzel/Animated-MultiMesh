extends MultiMeshInstance2D

## The main class of the plugin, it is a multimesh that uses a spritesheet to animate. 
class_name AnimatedMultiMesh

## The more complex application of the plugin
@export var complex:bool = false
## The speed of the animation
@export var animationSpeed:float = 1.0

@export_category("Spritesheet Settings")
## the horizontal rows in the spritesheet
@export var rowsInSheet = 1
## the vertical columns in the spritesheet
@export var columnsInSheet = 1

@onready var multi = get_multimesh()

func _ready():
	var shader = get_material()
	shader.set_shader(preload("res://addons/AnimatedMultiMesh/MultiMeshAnimation.gdshader"))
	shader.set_shader_parameter("col", float(columnsInSheet))
	shader.set_shader_parameter("row", float(rowsInSheet))
	if complex != true:
		demo_test_simple()

var complexTimer = 0.0
func _process(delta):
	animate(delta)
	if complex == true:
		complexTimer += delta
		if complexTimer > animationSpeed:
			activate()
			complexTimer = 0.0

#Custom data = Color(nothing, offsetx, offsety, currentTime)
func animate(delta):
	for num in multi.get_instance_count():
		var data:Color = multi.get_instance_custom_data(num)
		if complex == true:
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

var currentIdx = 0

func activate():
	var screen = get_viewport_rect().size
	var v = Vector2(randf() * screen.x, randf() * screen.y)
	var t = Transform2D(deg_to_rad(180), v)
	multi.set_instance_transform_2d(currentIdx, t)
	multi.set_instance_custom_data(currentIdx, Color(1.0,0.0,0.0,0.0))
	currentIdx += 1


func demo_test_simple():
	var screen = get_viewport_rect().size
	for i in multi.get_instance_count():
		#setting it 1.0 or visible (check shader)
		multi.set_instance_custom_data(i, Color(1.0,0.0,0.0,0.0))
		var v = Vector2(randf() * screen.x, randf() * screen.y)
		var t = Transform2D(deg_to_rad(180), v)
		multi.set_instance_transform_2d(i, t)