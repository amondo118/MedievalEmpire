extends Node
const Models = preload("uid://bo0lqe2x4opmc")
const Interactions = preload("uid://diq5r4c2mopmn")
const Classes = preload("uid://dersxqgqlkdbj")
const TREE = preload("uid://dnkp0qwyqtp7j")

var treenodes: Models.NaturalResource
var children : Array[Node2D]



func _ready():
	treenodes=Models.NaturalResource.new("tree")
	for tree in get_children():
		children.append(tree)
		treenodes.positions.append(tree.position)
		
func get_nearest(pos_:Vector2):
	var nearest = null
	var nearest_dist = INF
	
	
	for p in treenodes.positions:
		var dist =  p.distance_squared_to(pos_)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = p
	return nearest

func cut_tree(i:int):
	treenodes.positions.remove_at(i)
	remove_child(children[i])
	
