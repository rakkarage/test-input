extends Control

@onready var _icon := $TextureRect
@onready var _back := $PanelContainer/VBoxContainer/HBoxContainer/Back
@onready var _fore := $PanelContainer/VBoxContainer/HBoxContainer/Fore
@onready var _scroll_bar := $PanelContainer/VBoxContainer/HBoxContainer/HScrollBar

var _dragging := false

func _ready() -> void:
	_back.pressed.connect(_back_pressed)
	_fore.pressed.connect(_fore_pressed)
	_scroll_bar.value_changed.connect(_drag_to)
	_scroll_bar.min_value = 0
	_scroll_bar.max_value = get_viewport().size.x - _icon.size.x
	_scroll_bar.step = 1
	_drag_to(0)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_dragging = true
			else:
				_dragging = false
	elif event is InputEventMouseMotion:
		if _dragging:
			print("dragging")
			if _icon.global_position.x + event.relative.x < 0:
				_drag_to(0)
			elif _icon.global_position.x + event.relative.x > get_viewport().size.x - _icon.size.x:
				_drag_to(get_viewport().size.x - _icon.size.x)
			else:
				_drag_to(_icon.global_position.x + event.relative.x)

func _back_pressed() -> void:
	_drag_to(_icon.global_position.x - _icon.size.x)

func _fore_pressed() -> void:
	_drag_to(_icon.global_position.x + _icon.size.x)

func _drag_to(x: float) -> void:
	print("drag to", x)
	_icon.global_position.x = x
	_scroll_bar.set_value_no_signal(x)
	_back.disabled = _icon.global_position.x <= 0
	_fore.disabled = _icon.global_position.x >= get_viewport().size.x - _icon.size.x
