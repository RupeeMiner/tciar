extends Node2D

const section_time := 1.8
const line_time := 0.2
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.DARK_RED

# var scroll_speed := base_speed
var speed_up := false

@onready var line := $SubViewportContainer/SubViewport/CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"A game by A Good Company"
	],[
		"Programming",
		"Maeby Neaves",
		"Sam Barks"
	],[
		"Food Aliens",
		"Jonkler Juice",
		"Cumbersome Cucumber",
		"Lumbering Lettuce",
		"Bouncing Bun",
		"Cristo Cheese",
		"Bowling Beef",
		"Tumbling Tomato",
		"Marinated Meatball",
		"Nude Noodles",
		"Tantilizing Tater",
		"Elevated Egg",
		"Thicc Bacon"
	],[
		"Art",
		"Jose Garrido-Iniguez",
		"Sam Cloyd",
		"Haden Dorsch",
		"Garen Meinerding"
	],[
		"Customers",
		"Kah' Haehun",
		"Horkent",
		"Vokunal",
		"Pri' Mok"
	],[
		"Music",
		"Haden Dorsch",
		"Garen Meinerding"
	],[
		"Staff",
		"Da Baus",
		"Tony Rigatony, AKA Chef"
	],[
		"Sound Effects",
		"Sam Barks"
	],[
		"Game Design/Writing",
		"Sam Barks",
		"Haden Dorsch"
	],[
		"Font",
		"VCR OSD Mono by Riciery Leal",
	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"Art created with Aesprite"
	],[
		"Godot Credits",
		"Dialogic Plugin",
		"by Jowan-Spooner and Emilio Coppola",
		"Copyright (c) 2020 - present",
		"Emilio Coppola",
		"MIT License",
		"Godot Credits",
		"Ben Bishop",
		"Copyright (c) 2019 Ben Bishop",
		"MIT License",
		"",
		"Permission is hereby granted,",
		"free of charge, to any person",
		"obtaining a copy of this software", 
		"and associated documentation files",
		'(the "Software"),to deal in the',
		"Software without restriction,",
		"including without limitation",
		"the rights to use, copy, modify,",
		"merge, publish, distribute,",
		"sublicense, and/or sell copies",
		"of the Software, and to permit",
		"persons to whom the Software",
		"is furnished to do so, subject",
		"to the following conditions:",
		"The above copyright notice and",
		"this permission notice shall be",
		"included in all copies or substantial",
		"portions of the Software.",
		'THE SOFTWARE IS PROVIDED "AS IS",',
		"WITHOUT WARRANTY OF ANY KIND,",
		"EXPRESS OR IMPLIED, INCLUDING BUT",
		"NOT LIMITED TO THE WARRANTIES OF",
		"MERCHANTABILITY, FITNESS FOR",
		"A PARTICULAR PURPOSE AND",
		"NONINFRINGEMENT. IN NO EVENT SHALL",
		"THE AUTHORS OR COPYRIGHT HOLDERS",
		"BE LIABLE FOR ANY CLAIM, DAMAGES",
		"OR OTHER LIABILITY, WHETHER IN",
		"AN ACTION OF CONTRACT, TORT OR",
		"OTHERWISE, ARISING FROM, OUT OF",
		"OR IN CONNECTION WITH THE",
		"SOFTWARE OR THE USE OR OTHER",
		"DEALINGS IN THE SOFTWARE."
	],[
		"Special thanks",
		"Drennon Dooms",
		"Everyone in Class",
		"Thicc Ass Bacon",
	],[
		"And You!"
	]
]

func _process(delta):
	var scroll_speed = base_speed * delta
	
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.position.y -= scroll_speed
			if l.position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		# This is called when the credits finish and returns to the main menu
		WorldState.load_scene("Title")


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		# new_line.add_color_override("font_color", title_color)
		new_line.set("theme_override_colors/font_color", title_color)
	$SubViewportContainer/SubViewport/CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
