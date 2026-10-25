class_name DeleteWhenOffScreen
extends Node

@export var visible_notifier: VisibleOnScreenNotifier2D
@export var off_screen_timer: Timer

@export_range(-1.0, 60.0, 0.1, "or_greater") var off_screen_time_allowed: float = -1.0
@export var target_node: Node ## Defaults to the parent node if left empty.

func _ready() -> void:
	# Default target to parent if not explicitly set
	if not target_node:
		target_node = get_parent()

	# Auto-detect nodes if not assigned in the inspector
	if not visible_notifier:
		visible_notifier = _find_notifier()

	if not off_screen_timer:
		push_error("DeleteWhenOffScren: Timer not set!")

	# Validation check
	if not visible_notifier:
		push_error("DeleteWhenOffScreen: Missing VisibleOnScreenNotifier2D reference on %s" % target_node.name)
		return

	# Configure the timer
	if off_screen_timer:
		off_screen_timer.one_shot = true

	# Connect signals safely
	if not visible_notifier.screen_exited.is_connected(_on_screen_exited):
		visible_notifier.screen_exited.connect(_on_screen_exited)
	
	if not visible_notifier.screen_entered.is_connected(_on_screen_entered):
		visible_notifier.screen_entered.connect(_on_screen_entered)
		
	if off_screen_timer and not off_screen_timer.timeout.is_connected(_on_timer_timeout):
		off_screen_timer.timeout.connect(_on_timer_timeout)

func _on_screen_exited() -> void:
	if off_screen_time_allowed <= 0.0:
		_delete_target()
	elif off_screen_timer:
		off_screen_timer.start(off_screen_time_allowed)

func _on_screen_entered() -> void:
	# If the object returns to the screen before the timer expires, cancel deletion
	if off_screen_timer and not off_screen_timer.is_stopped():
		off_screen_timer.stop()

func _on_timer_timeout() -> void:
	_delete_target()

func _delete_target() -> void:
	if is_instance_valid(target_node):
		target_node.queue_free()

func _find_notifier() -> VisibleOnScreenNotifier2D:
	# Check direct children first
	var notifier = get_node_or_null("VisibleOnScreenNotifier2D") as VisibleOnScreenNotifier2D
	if notifier:
		return notifier
		
	# Check siblings under the parent node
	if target_node:
		for child in target_node.find_children("*", "VisibleOnScreenNotifier2D", false, false):
			return child as VisibleOnScreenNotifier2D
			
	return null
