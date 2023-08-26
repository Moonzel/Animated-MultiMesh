extends AnimatedMultiMesh

class_name AnimatedMultiMeshTest

##The more complex application of the plugin, it demonstrates how each instance can animate on its own.
@export var complex:bool = false

# first two functions are needed to work
func _ready():
	_setup()
	_set_shader(self)
	if complex != true:
		demo_test_simple()

func _process(delta):
	animate(delta)
	if complex == true and spawn == true:
		var screen = get_viewport_rect().size
		spawnPosition = Vector2(randf() * screen.x, randf() * screen.y)
		check_for_spawn(delta)

func demo_test_simple():
	var screen = get_viewport_rect().size
	for i in multi.get_instance_count():
		#setting it 1.0 / visible (check shader)
		multi.set_instance_custom_data(i, Color(1.0,0.0,0.0,0.0))
		var v = Vector2(randf() * screen.x, randf() * screen.y)
		var t = Transform2D(deg_to_rad(180), v)
		multi.set_instance_transform_2d(i, t)
