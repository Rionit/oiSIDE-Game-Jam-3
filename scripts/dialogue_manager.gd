extends CanvasLayer

signal dialogue_finished
signal all_dialogue_finished

@onready var label: RichTextLabel = $DialogueBox/MarginContainer/RichTextLabel
@onready var background_box: ColorRect = $DialogueBox/MarginContainer/BackgroundBox

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
		var formatted_text
		var sfx_name = "tsk_female" if line.speaker == DialogueLine.Speaker.WIFE else "tsk_male"
		
		if line.speaker == DialogueLine.Speaker.BUDDY:
			background_box.color = Color.BLACK
			formatted_text = "[color=white]%s[/color]" % line.text
		elif line.speaker == DialogueLine.Speaker.WIFE:
			background_box.color = Color.BLACK
			formatted_text = "[color=white]%s[/color]" % line.text
		elif line.speaker == DialogueLine.Speaker.PLAYER:
			background_box.color = Color.WHITE
			formatted_text = "[color=black]%s[/color]" % line.text
		
		display_text(formatted_text, 0.03, sfx_name)
		current_dialogue_index += 1
	else:
		all_dialogue_finished.emit()
		visible = false

func display_text(text: String, speed: float = 0.03, sfx_name: String = "tsk_male") -> void:
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	label.text = text
	label.visible_characters = 0
	
	var total_chars = label.get_total_character_count()
	if total_chars == 0:
		dialogue_finished.emit()
		return
		
	var last_played_char: int = 0
	current_tween = create_tween()
	current_tween.tween_method(func(v: float):
		var current_char = int(v)
		if current_char > last_played_char:
			if current_char % 3 == 0:
				AudioManager.play_sfx(sfx_name)
			last_played_char = current_char
		label.visible_characters = current_char
	, 0.0, float(total_chars), total_chars * speed)
	
	await current_tween.finished
	dialogue_finished.emit()

func _on_dialogue_finished() -> void:
	waiting_for_input = true

func _input(event: InputEvent) -> void:
	if waiting_for_input and event.is_action_pressed("interact"):
		waiting_for_input = false
		play_next_line()
