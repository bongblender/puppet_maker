@tool
extends EditorPlugin

var dock: VBoxContainer
var funcs

func _enter_tree():
	var FuncScript = load("res://addons/puppet/puppet_functions.gd")
	funcs = FuncScript.new(get_editor_interface())

	dock = VBoxContainer.new()
	dock.name = "Puppet"

	# --- ROW 1---
	var row1 = HBoxContainer.new()
	var lbl = Label.new()
	lbl.text = "Create Bone On Point"
	row1.add_child(lbl)
	var input1 = LineEdit.new()
	input1.placeholder_text = "pos X"
	input1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input1.custom_minimum_size = Vector2(100.0, 25.0)   # Wider, avoids 0 size
	row1.add_child(input1)
	var input2 = LineEdit.new()
	input2.placeholder_text = "pos Y"
	input2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input2.custom_minimum_size = Vector2(100.0, 25.0)   # Wider, avoids 0 size
	row1.add_child(input2)
	var input3 = LineEdit.new()
	input3.placeholder_text = "bone name"
	input3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input3.custom_minimum_size = Vector2(100.0, 25.0)   # Wider, avoids 0 size
	row1.add_child(input3)
	var btn = Button.new()
	btn.text = "Create"
	btn.pressed.connect(func():
		if funcs and funcs.has_method("create_bone"):
			funcs.create_bone(input1.text.to_float(), input2.text.to_float(), input3.text ))
	row1.add_child(btn)
# --- ROW 2---
	var row2 = HBoxContainer.new()
	var lbl2 = Label.new()
	lbl2.text = "setup_charecter"
	row2.add_child(lbl2)
	
	var btn2 = Button.new()
	btn2.text = "Create"
	btn2.pressed.connect(func():
		if funcs and funcs.has_method("setup_character"):
			funcs.setup_character()
	)
	row2.add_child(btn2)

	var lbl3 = Label.new()
	lbl3.text = "Static Bone Setup"
	row2.add_child(lbl3)
	
	var btn3 = Button.new()
	btn3.text = "Create"
	btn3.pressed.connect(func():
		if funcs and funcs.has_method("create_sprite_for_bone"):
			funcs.create_sprite_for_bone()
	)
	row2.add_child(btn3)

	var lbl4 = Label.new()
	lbl4.text = "Dynamic Bone Setup"
	row2.add_child(lbl4)
	
	var btn4 = Button.new()
	btn4.text = "Create"
	btn4.pressed.connect(func():
		if funcs and funcs.has_method("create_polygon_for_bone"):
			funcs.create_polygon_for_bone()
	)
	row2.add_child(btn4)

	dock.add_child(row1)
	dock.add_child(row2)
	add_control_to_bottom_panel(dock, "Puppet")
	

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
