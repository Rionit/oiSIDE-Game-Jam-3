extends CanvasLayer

signal dialogue_finished
signal all_dialogue_finished

@onready var label: RichTextLabel = $DialogueBox/MarginContainer/RichTextLabel

var dialogue_lines: Array[DialogueLine] = []
var current_dialogue_index: int = 0
var waiting_for_input: bool = false
var current_tween: Tween

func _ready() -> void:
	dialogue_finished.connect(_on_dialogue_finished)

func start_dialogue(lines: Array[DialogueLine]) -> void:
	visible = true
	dialogue_lines = lines
	current_dialogue_index = 0
	play_next_line()

func play_next_line() -> void:
	if current_dialogue_index < dialogue_lines.size():
		var line = dialogue_lines[current_dialogue_index]
		var formatted_text = "[b][color=yellow]%s:[/color][/b] %s" % [line.speaker, line.text]
		display_text(formatted_text)
		current_dialogue_index += 1
	else:
		all_dialogue_finished.emit()
		visible = false

func display_text(text: String, speed: float = 0.03) -> void:
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	label.text = text
	label.visible_characters = 0
	
	var total_chars = label.get_total_character_count()
	if total_chars == 0:
		dialogue_finished.emit()
		return
		
	current_tween = create_tween()
	current_tween.tween_property(label, "visible_characters", total_chars, total_chars * speed)
	
	await current_tween.finished
	dialogue_finished.emit()

func _on_dialogue_finished() -> void:
	waiting_for_input = true

func _input(event: InputEvent) -> void:
	if waiting_for_input and event.is_action_pressed("interact"):
		waiting_for_input = false
		play_next_line()
