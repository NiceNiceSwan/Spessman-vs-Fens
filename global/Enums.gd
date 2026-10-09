extends Node

enum STATUS_EFFECTS {
	## No status effect, used by the base node
	NONE,
	## Slows the enemies movement and attack speed
	SLOW,
	## Completely stops the enemy
	FREEZE,
	## Periodically applies damage (NOT IMPLEMENTED)
	FIRE
}

enum UNLOCKS {
	NONE = 0,
	SUNFLOWER = 1,
	POTATO_MINE = 2,
	WALLNUT = 3,
	ICEPEA = 4,
	SM_CRYSTAL = 5,
	CHOMPER = 6,
	REPEATER = 7,
	SQUASH = 8,
	MESSAGE_ONE = 9,
	SPEAKER_TOWER = 10,
	CHALOE = 11,
	DRAGON = 12,
	FUME_SHROOM = 13,
	SPIKEWEED = 14,
	MESSAGE_TWO = 15,
	CHEERY_BOMB = 16,
	ICE_SHROOM = 17,
	STARFRUIT = 18,
	ALL = 19
}

enum CARD_STYLES {
	DEFAULT,
	ENGINEERING,
	MEDICAL,
	SCIENCE,
	CARGO,
	SERVICE,
	SECURITY,
	COMMAND,
	GATO,
}
