extends Sprite2D

@export var player: Node2D
@export var coolers: Array[Node2D]
@export var rest_area: Node2D
@export var exit_area: Node2D

var vectors = [Vector2(0,1), Vector2(1,1), Vector2(1,0), Vector2(1, -1), Vector2(0, -1), Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1)]
var dirs = ["down", "downright", "right", "upright", "up", "upleft", "left", "downleft"]

var recipe_ready = false

func _ready():
	recipe_ready = !WorldState.ingredients_missing()
	WorldState.recipe_ready.connect(ready_recipe)
	Options.guide_toggled.connect(toggle)
	
	visible = Options.guide_active

func toggle(toggled_on):
	visible = toggled_on

func _process(delta):
	var target: Node2D
	if (recipe_ready):
		target = exit_area
	elif (PlayerState.current_health <= 5):
		target = rest_area
	else:
		var closed_coolers = []
		for i in range(WorldState.coolers_closed.size()):
			if (WorldState.coolers_closed[i]):
				closed_coolers.append(i)
		if closed_coolers.size() == 0:
			target = rest_area
		else:
			var cooler_dirs = []
			for cooler_id in closed_coolers:
				cooler_dirs.append((coolers[cooler_id].global_position - player.global_position).length())
			target = coolers[closed_coolers[cooler_dirs.find(cooler_dirs.min())]]
	
	var direction: Vector2 = (target.global_position - player.global_position).normalized()
	
	var dot_products = []
	for i in range(vectors.size()):
		dot_products.append(vectors[i].normalized().dot(direction))
	
	var result = dot_products.find(dot_products.max())
	print (dirs[result])

func ready_recipe(current_recipe):
	recipe_ready = true
	print("I'm here")
