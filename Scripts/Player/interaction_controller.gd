extends Node2D

var selected_entity := ""
var selected_building := ""
var selected_kin := ""
var build := false
var mouse_query := PhysicsPointQueryParameters2D.new()

signal building_selected(target_id: String)
signal kin_selected(target_id: String)
signal deselect


signal to_build(b: int)
signal build_at(pos: Vector2)


const PICK_PRIORITY: Array[String] = ["Kin", "Buildings", "Resources", "Animals", "Ground"]

func _ready() -> void:
	mouse_query.collide_with_areas = true
	mouse_query.collide_with_bodies = true
	mouse_query.collision_mask = 1

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if select() == "" and build:
				build_at.emit(get_global_mouse_position())
				build = false


	if event.is_action_pressed("building_0"):
		toggle_build(1)
	elif event.is_action_pressed("building_1"):
		toggle_build(2)

func toggle_build(id: int) -> void:
	build = not build
	to_build.emit(id if build else 0)

func get_nodes_under_mouse() -> Array[Node]:
	mouse_query.position = get_global_mouse_position()
	var nodes: Array[Node] = []
	for result in get_world_2d().direct_space_state.intersect_point(mouse_query, 32):
		var node := result["collider"] as Node
		while node:
			nodes.append(node)
			node = node.get_parent()
	return nodes

func pick_under_mouse() -> Node:
	var nodes := get_nodes_under_mouse() 
	for g in PICK_PRIORITY:
		for node in nodes:
			if node.is_in_group(g):
				return node
	return null


func get_id(node: Node) -> String:
	if node != null and node.has_method("get_id"):
		return node.get_id()
	return ""

func select() -> String:
	var node := pick_under_mouse()
	selected_entity = get_id(node)
	if selected_entity == "":
		deselect.emit()
		return ""
	if node.is_in_group("Kin"):
		selected_kin = selected_entity
		kin_selected.emit(selected_kin)
		return selected_kin
	if node.is_in_group("Buildings"):
		selected_building = selected_entity
		building_selected.emit(selected_building)
		return selected_building
	return ""  
