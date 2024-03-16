extends StaticBody2D

@export_enum("A", "B", "C") var asset_variant: int = 0:
	set = set_rock

func set_rock(value):
	for i in %Assets.get_children():
		i.visible = false
	%Assets.get_child(value).visible = true
	notify_property_list_changed()

