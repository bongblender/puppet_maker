extends RefCounted
class_name PuppetFunctions

var editor: EditorInterface

func _init(editor_interface: EditorInterface):
	editor = editor_interface

func create_bone(pos_x: float, pos_y: float, name: String) -> void:
	var selection = editor.get_selection()
	var selected_nodes = selection.get_selected_nodes()
	
	if selected_nodes.size() != 1 or not selected_nodes[0] is Bone2D:
		push_error("Please select exactly one Bone2D node to add a child bone to")
		return
	
	var parent_bone: Bone2D = selected_nodes[0]
	var new_bone = Bone2D.new()
	new_bone.name = name
	
	# Explicitly set bone properties to avoid warnings
	var angle_rad = deg_to_rad(45)
	var bone_length = 100.0
	
	# Set rest transform directly
	new_bone.rest = Transform2D(angle_rad, Vector2(bone_length, 0))
	
	# Disable auto-calculation since we're setting properties manually
	new_bone.auto_calculate_length_and_angle = false
	
	# Add to hierarchy
	parent_bone.add_child(new_bone)
	new_bone.owner = editor.get_edited_scene_root()
	
	# Set global position after adding to scene tree
	new_bone.global_position = Vector2(pos_x, pos_y)
	
	print("Created bone '%s' at global position (%.2f, %.2f)" % [name, pos_x, pos_y])

func setup_character():
	# Get the edited scene root
	var scene_root = editor.get_edited_scene_root()
	if not scene_root:
		push_error("No active scene!")
		return
	
	# Check for existing nodes
	var has_bones = scene_root.get_node_or_null("Bones") != null
	var has_sprites = scene_root.get_node_or_null("Sprites") != null
	
	if has_bones or has_sprites:
		push_warning("Skipping setup: 'Bones' or 'Sprites' already exists")
		return
	
	# Create Bones node
	var bones = Node2D.new()
	bones.name = "Bones"
	scene_root.add_child(bones)
	bones.owner = scene_root
	
	# Create Sprites node
	var sprites = Node2D.new()
	sprites.name = "Sprites"
	scene_root.add_child(sprites)
	sprites.owner = scene_root
	
	# Create Skeleton2D as child of Bones
	var skeleton = Skeleton2D.new()
	skeleton.name = "Skeleton2D"
	bones.add_child(skeleton)
	skeleton.owner = scene_root
	
	# Create Bone2D as child of Skeleton2D
	var bone = Bone2D.new()
	bone.name = "Bone2D"
	skeleton.add_child(bone)
	bone.owner = scene_root
	
	print("Character setup complete")





func create_sprite_for_bone() -> void:
	var selection = editor.get_selection()
	var selected_nodes = selection.get_selected_nodes()
	
	# Validate selection
	if selected_nodes.size() != 1 or not selected_nodes[0] is Bone2D:
		push_error("Please select exactly one Bone2D node")
		return
	
	var bone: Bone2D = selected_nodes[0]
	var scene_root = editor.get_edited_scene_root()
	if not scene_root:
		push_error("No active scene!")
		return
	
	# Find Sprites node
	var sprites_node = scene_root.get_node_or_null("Sprites")
	if not sprites_node:
		push_error("Sprites node not found. Run setup_character first.")
		return
	
	# Create sprite
	var sprite = Sprite2D.new()
	sprite.name = bone.name + "_sp"
	sprites_node.add_child(sprite)
	sprite.owner = scene_root
	
	# Position sprite at bone's global position
	sprite.global_position = bone.global_position
	
	# Create RemoteTransform2D
	var remote_transform = RemoteTransform2D.new()
	remote_transform.name = bone.name + "_tr"
	bone.add_child(remote_transform)
	remote_transform.owner = scene_root
	
	# Connect RemoteTransform2D to sprite
	remote_transform.remote_path = remote_transform.get_path_to(sprite)
	
	print("Created sprite and remote transform for bone: %s" % bone.name)
	
	
	
	
	
func create_polygon_for_bone() -> void:
	var selection = editor.get_selection()
	var selected_nodes = selection.get_selected_nodes()
	
	# Validate selection
	if selected_nodes.size() != 1 or not selected_nodes[0] is Bone2D:
		push_error("Please select exactly one Bone2D node")
		return
	
	var bone: Bone2D = selected_nodes[0]
	var scene_root = editor.get_edited_scene_root()
	if not scene_root:
		push_error("No active scene!")
		return
	
	# Find Sprites node
	var sprites_node = scene_root.get_node_or_null("Sprites")
	if not sprites_node:
		push_error("Sprites node not found. Run setup_character first.")
		return
	
	# Find Skeleton2D node (assumes it's in the Bones node)
	var bones_node = scene_root.get_node_or_null("Bones")
	if not bones_node:
		push_error("Bones node not found. Run setup_character first.")
		return
	
	var skeleton = bones_node.get_node_or_null("Skeleton2D")
	if not skeleton or not skeleton is Skeleton2D:
		push_error("Skeleton2D not found. Run setup_character first.")
		return
	
	# Create Polygon2D
	var polygon = Polygon2D.new()
	polygon.name = bone.name + "_poly"
	sprites_node.add_child(polygon)
	polygon.owner = scene_root
	
	# Set default polygon (simple square)
	var size = 20
	polygon.polygon = PackedVector2Array([
		Vector2(-size, -size),
		Vector2(size, -size),
		Vector2(size, size),
		Vector2(-size, size)
	])
	
	# Position polygon at bone's global position
	polygon.global_position = bone.global_position
	
	# Set skeleton properties only
	polygon.skeleton = polygon.get_path_to(skeleton)
	
	print("Created polygon for bone: %s" % bone.name)
