extends Node2D

var selected_building
var build= false
var mouse_querry:=PhysicsPointQueryParameters2D.new()

signal building_selected(target_id:String)
signal assign_kin_to(taget_id:String)
signal to_build(b :int)
signal build_at(pos:Vector2)

func _ready() -> void:
	mouse_querry.collide_with_areas =true
	mouse_querry.collide_with_bodies = true
	mouse_querry.collision_mask =1
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index ==MOUSE_BUTTON_LEFT and event.pressed:
			if select_building()== null and build==true:
				build_at.emit(get_global_mouse_position())
				build=false
		elif event.button_index ==MOUSE_BUTTON_RIGHT and event.pressed:
			if selected_building != null and pick_under_mouse("Buildings")==selected_building:
				assign_kin_to.emit(selected_building)
	
	
	if event is InputEventKey:
		if event.is_action("building_0") and event.pressed:
			if not build:
				to_build.emit(1)
				build=true
			else:
				to_build.emit(0)
				build=false
		elif event.is_action("building_1") and event.pressed:
			if not build:
				to_build.emit(2)
				build=true
			else:
				to_build.emit(0)
				build=false
			
const PICK_PRIORITY: Array[String] = ["Kin", "Resources", "Buildings", "Animals", "Ground"]

func get_nodes_under_mouse() -> Array[Node]:
	mouse_querry.position = get_global_mouse_position()
	var nodes: Array[Node] = []
	for result in get_world_2d().direct_space_state.intersect_point(mouse_querry, 32):
		var node := result["collider"] as Node
		while node:
			nodes.append(node)
			node = node.get_parent()
	return nodes

func pick_under_mouse(group: String):
	for node in get_nodes_under_mouse():
		if node.is_in_group(group):
			return node.get_id()
	return null

func select_building():
	selected_building = pick_under_mouse("Buildings")
	if selected_building:
		building_selected.emit(selected_building)
		return selected_building
	return null
