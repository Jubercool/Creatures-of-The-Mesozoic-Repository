extends Node

var creatures = {
	"ischigualastia":{
		"max_health":150,
		"damage":[17],
		"walk_max_vel":150,
		"sprint_max_vel":300,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2],
		"size":Vector2(1,1),
		"sprite_offset":Vector2i(0,20),
		"hitbox":[96,370],
		"attack_hitbox":[[233,810]],
	},
	"herrerasaurus":{
		"max_health":35,
		"damage":[4],
		"walk_max_vel":325,
		"sprint_max_vel":750,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[1.5],
		"size":Vector2(0.35,0.35),
		"sprite_offset":Vector2i(-75,-15),
		"hitbox":[48,190],
		"attack_hitbox":[[132,440]],
	},
	"saurosuchus":{
		"max_health":100,
		"damage":[25],
		"walk_max_vel":225,
		"sprint_max_vel":450,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2],
		"size":Vector2(1.4,1.4),
		"sprite_offset":Vector2i(-100,-75),
		"hitbox":[85,438],
		"attack_hitbox":[[162,730]],
	},
	"eoraptor":{
		"max_health":8,
		"damage":[1],
		"walk_max_vel":375,
		"sprint_max_vel":850,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2],
		"size":Vector2(0.3,0.3),
		"sprite_offset":Vector2i(-20,0),
		"hitbox":[15,100],
		"attack_hitbox":[[52,214]],
	},
	"player":{
		"max_health":100,
		"damage":[25],
		"walk_max_vel":400,
		"sprint_max_vel":900,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[1],
		"size":Vector2(1,1),
		"sprite_offset":Vector2i(0,0),
		"hitbox":[79,320],
		"attack_hitbox":[[126,486]],
	}
}

var dinopedia = [
	{
		"name":"ischigualastia",
		"dinopedia_unlocked":false,
		"dinopedia_left_page":"ischigualastia",
		"dinopedia_right_page":"HELP ME AAAAAAAA",
		"size":Vector2(0.8,0.8),
		"offset":Vector2i(-10,-10),
	},
	{
		"name":"herrerasaurus",
		"dinopedia_unlocked":false,
		"dinopedia_left_page":"herrerasaurus",
		"dinopedia_right_page":"HELP ME AAAAAAAA",
		"size":Vector2(0.3,0.3),
		"offset":Vector2i(-50,-50),
	},
	{
		"name":"saurosuchus",
		"dinopedia_unlocked":false,
		"dinopedia_left_page":"saurosuchus",
		"dinopedia_right_page":"HELP ME AAAAAAAA",
		"size":Vector2(0.7,0.7),
		"offset":Vector2i(-50,-55),
	},
	{
		"name":"eoraptor",
		"dinopedia_unlocked":false,
		"dinopedia_left_page":"eoraptor",
		"dinopedia_right_page":"HELP ME AAAAAAAA",
		"size":Vector2(0.8,0.8),
		"offset":Vector2i(-50,-10),
	},
]

var info_screens = [
	{
		"flora":"Conifer trees and small ferns were present throughout. Presence of a volcano in combination with the overall arid conditions makes it a challenge to survive for animals found living in this location.",
		"title":"Ischigualasto Formation, 230 million years ago.",
		"dinos":[
			"Ischigualastia -\nSize: 3.5-4 metres long, 1-2 tonnes\nDiet: Herbivore\nTips: Peaceful unless provoked, best to leave it alone",
			"Eoraptor -\nSize: 1 metre long, 8-10 kg\nDiet: Carnivore\nTips: Attacks on sight, small size makes it an annoyance",
			"Saurosuchus -\nSize: 7 metres long, 750 kg\nDiet: Carnivore\nTips: Attacks on sight and possesses deadly jaws, use your speed advantage to get away",
			"Herrerasaurus -\nSize: 5-6 metres long, 350 kg\nDiet: Carnivore\nTips: Attacks on sight, with a couple attacks finishing it off",
		],
	},
]

var menu = "info"
var page = 0
var level = 0
var running = true
