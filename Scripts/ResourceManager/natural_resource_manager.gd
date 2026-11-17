extends Node

const TREE_DATA = preload("uid://cxt5gglap60b6")
@onready var world: Node2D = $"../../World"



var treenodes: Dictionary[Node2D,NaturalResource]


func load_bootstrap(b:Resource):
		for tree_pos in b.trees:
			var t:Node2D = TREE_DATA.scene.instantiate()
			t.position=tree_pos
			treenodes[t]=NaturalResource.new(TREE_DATA,tree_pos)
			treenodes[t].depleted.connect(_on_depleted)
			world.add_child(t)

func _ready():
	pass

		
func get_nearest_pos(pos_:Vector2):
	var nearest = null
	var nearest_dist = INF
	
	
	for p in treenodes.values():
		var dist =  p.position.distance_squared_to(pos_)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = p.position
	return nearest.marker
	
func get_nearest(pos_:Vector2):
	var nearest = null
	var nearest_dist = INF
	
	
	for p in treenodes.values():
		var dist =  p.position.distance_squared_to(pos_)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = p
	return nearest



	
func _on_depleted(model: NaturalResource):
	var node = treenodes.find_key(model)
	if node != null:
		treenodes.erase(node)
		node.queue_free()

func _on_managers_on_tick() -> void:
	pass
