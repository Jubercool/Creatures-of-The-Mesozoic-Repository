extends Node

var creatures = {
	"ischigualastia":{
		"max_health":150,
		"damage":[17],
		"bleed":[10],
		"walk_max_vel":150,
		"sprint_max_vel":300,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2],
		"sprite_size":Vector2(1,1),
		"sprite_offset":Vector2i(0,20),
		"hitbox_size":[96,370],
		"hitbox_offset":Vector2i(0,0),
		"attack_hitbox_size":[[233,810]],
		"attack_hitbox_offset":[Vector2i(0,0)],
	},
	"herrerasaurus":{
		"max_health":35,
		"damage":[4],
		"bleed":[10],
		"walk_max_vel":325,
		"sprint_max_vel":750,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[1.5],
		"sprite_size":Vector2(0.35,0.35),
		"sprite_offset":Vector2i(-75,-15),
		"hitbox_size":[48,190],
		"hitbox_offset":Vector2i(0,0),
		"attack_hitbox_size":[[132,440]],
		"attack_hitbox_offset":[Vector2i(0,0)],
	},
	"saurosuchus":{
		"max_health":100,
		"damage":[25],
		"bleed":[10],
		"walk_max_vel":225,
		"sprint_max_vel":450,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2],
		"sprite_size":Vector2(1.4,1.4),
		"sprite_offset":Vector2i(-100,-75),
		"hitbox_size":[85,438],
		"hitbox_offset":Vector2i(0,0),
		"attack_hitbox_size":[[162,730]],
		"attack_hitbox_offset":[Vector2i(0,0)],
	},
	"eoraptor":{
		"max_health":8,
		"damage":[1],
		"bleed":[10],
		"walk_max_vel":375,
		"sprint_max_vel":850,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[2],
		"sprite_size":Vector2(0.3,0.3),
		"sprite_offset":Vector2i(-20,0),
		"hitbox_size":[15,100],
		"hitbox_offset":Vector2i(0,0),
		"attack_hitbox_size":[[52,214]],
		"attack_hitbox_offset":[Vector2i(0,0)],
	},
	"player":{
		"max_health":100,
		"attack_amount":2,
		"damage":[25,30],
		"walk_max_vel":400,
		"sprint_max_vel":900,
		"acceleration_base":70,
		"acceleration_buff":100,
		"attack_cooldown":[1,2],
		"sprite_size":Vector2(1,1),
		"sprite_offset":Vector2i(0,0),
		"hitbox_size":[79,320],
		"hitbox_offset":Vector2i(0,0),
		"attack_hitbox_size":[[126,486],[126,486]],
		"attack_hitbox_offset":[Vector2i(0,0),Vector2i(0,0)],
		"attack_input":["left_click"],
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
var homecave = false
var running = true
var sprint_toggle = false
var controller = false
