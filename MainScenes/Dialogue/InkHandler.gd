extends Control

signal story_has_tags(tags)
signal story_section_complete

@onready var story_label = $HBoxContainer/ColorRect/MarginContainer/VBoxContainer/Label
@onready var choices_container = $HBoxContainer/ColorRect/MarginContainer/VBoxContainer/ChoicesContainer

var choice_button: PackedScene = preload("res://Dialogue/choice_button.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StoryManager.ink_player.connect("continued", _continue_story)
	StoryManager.ink_player.connect("prompt_choices", _prompt_choices)
	StoryManager.ink_player.connect("ended", on_story_ended)
	
	StoryManager.ink_player.continue_story()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if not StoryManager.ink_player.has_choices:
				#print("Mouse Click/Unclick at: ", event.position)
				StoryManager.ink_player.continue_story()


func _continue_story(text: String, tags) -> void:
	print("continue story")
	if tags:
		story_has_tags.emit(tags)
	
	story_label.text = text
	
	if StoryManager.ink_player.has_choices:
		StoryManager.ink_player.continue_story()


func _prompt_choices(choices: Array) -> void:
	print("prompt choices")
	if not choices.is_empty():
		choices_container.visible = true
		#print(choices)
		
		for choice in choices:
			var new_button = choice_button.instantiate()
			new_button.text = choice.text
			new_button.pressed.connect(_select_choice.bind(choice.index))
			choices_container.add_child(new_button)
			print(choice.index)


func on_story_ended() -> void:
	print("The End")
	visible = false
	story_section_complete.emit()


func _select_choice(index: int) -> void:
	print(index)
	choices_container.visible = false
	for child in choices_container.get_children():
		child.queue_free()
	
	StoryManager.ink_player.choose_choice_index(index)
	StoryManager.ink_player.continue_story()


func _on_next_button_pressed() -> void:
	StoryManager.ink_player.continue_story()
