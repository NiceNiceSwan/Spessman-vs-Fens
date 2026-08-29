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
	CHEERY_BOMB = 15,
	ICE_SHROOM = 16,
	STARFRUIT = 17,
	ALL = 18
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
}
