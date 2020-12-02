extends Node

class_name Protagonist

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path = []
var speed = 399
var map = null

onready var animated_sprite = $AnimatedSprite


func move_along_path(path: Array, map: DraftLevel, scale_factor):
	self.map = map
	for i in range(0, path.size()):
		path[i] = {
			'map': path[i],
			'world' : map.map_to_world(path[i]) / scale_factor
			}
	self.path = path	
	
func _move_to(distance):
	if self.path.size() <= 1:
		return
	
	var pos = self.global_position
	var start_point = self.path[0]
	var next_cell = self.path[1]
	var distance_to_next = pos.distance_to(next_cell['world'])
	if distance_to_next == 0.0 or distance > distance_to_next:		
		if self.path.size() == 2:
			self.path.pop_front()
			self.global_position = next_cell['world']
			return
		self.global_position = pos.linear_interpolate(next_cell['world'], distance / distance_to_next)
		self.path.pop_front()
		return
		
	self.global_position = pos.linear_interpolate(next_cell['world'], distance / distance_to_next)
	if next_cell['map'].x > start_point['map'].x:
		self.animated_sprite.animation = "SE"
	elif next_cell['map'].x < start_point['map'].x:
		self.animated_sprite.animation = "NW"
	elif next_cell['map'].y > start_point['map'].y:
		self.animated_sprite.animation = "SW"
	elif next_cell['map'].y < start_point['map'].y:
		self.animated_sprite.animation = "NE"
		
func _process(delta):
	var move_distance = delta * self.speed
	self._move_to(move_distance)
