extends Node

var creatures = {
	"ischigualastia":{
		"max_health":150,
		"damage":[17],
		"walk_max_vel":150,
		"sprint_max_vel":300,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2]
	},
	"herrerasaurus":{
		"max_health":35,
		"damage":[4],
		"walk_max_vel":325,
		"sprint_max_vel":750,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[1.5]
	},
	"saurosuchus":{
		"max_health":100,
		"damage":[25],
		"walk_max_vel":225,
		"sprint_max_vel":450,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2]
	},
	"eoraptor":{
		"max_health":8,
		"damage":[1],
		"walk_max_vel":375,
		"sprint_max_vel":850,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2]
	},
	"player":{
		"max_health":100,
		"damage":[25],
		"walk_max_vel":400,
		"sprint_max_vel":900,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2]
	}
}

var running = false
