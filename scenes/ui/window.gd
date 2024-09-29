extends Window

class_name BasicWindowDialog

@onready var yes_button: Button = $MarginContainer/YesButton
@onready var no_button: Button = $MarginContainer/NoButton
@onready var label: Label = $MarginContainer/Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	
func _on_close_requested() -> void:
	hide()
	get_tree().paused = false




func _on_no_button_pressed() -> void:
	SignalBus.on_basic_dialog_no_pressed.emit()
	get_tree().paused = false
	queue_free()


func _on_yes_button_pressed() -> void:
	SignalBus.on_basic_dialog_yes_pressed.emit()
	get_tree().paused = false
	queue_free()
