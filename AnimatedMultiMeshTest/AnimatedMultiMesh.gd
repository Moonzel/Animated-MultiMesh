extends MultiMeshInstance2D

## The main class of the plgin, it is a multimesh that uses a spritesheet to animate. 
class_name AnimatedMultiMesh

@export var animationSpeed:float = 1.0
@export_category("Spritesheet Settings")
@export var rowsInSheet = 1
@export var columnsInSheet = 1

@onready var multi = get_multimesh()

func _ready():
	var shader = get_material()
	shader.set_shader_parameter("col", float(columnsInSheet))
	shader.set_shader_parameter("row", float(rowsInSheet))
	demo_test()

func _process(delta):
	for i in multi.get_instance_count():
		animate(i, delta)

#Custom data = Color(nothing, offsetx, offsety, currentTime)
func animate(num, delta):
	var data:Color = multi.get_instance_custom_data(num)
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


func demo_test():
	var screen = get_viewport_rect().size
	for i in multi.get_instance_count():
		#setting it 1.0 or visible (check shader)
		multi.set_instance_custom_data(i, Color(1.0,0.0,0.0,0.0))
		var v = Vector2(randf() * screen.x, randf() * screen.y)
		var t = Transform2D(deg_to_rad(180), v)
		multi.set_instance_transform_2d(i, t)
