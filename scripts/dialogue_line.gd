class_name DialogueLine
extends Resource

enum Speaker {
	BUDDY,
	PLAYER,
	WIFE
}

@export var speaker: Speaker = Speaker.PLAYER
@export_multiline var text: String
