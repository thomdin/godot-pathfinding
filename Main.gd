extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const pathfinding = preload("res://scripts/Pathfinding.gd")
var cells : Array = []
var grid_positions_to_points : Dictionary = {}
var position_mouse : Vector2 = Vector2(0, 0)
var position_grid : Vector2 = Vector2(0, 0)
var level_scale_factor = 2 # Because the level is scaled to half of its size
var astar = AStar2D.new()
onready var debug : GridContainer = $Debug/MarginContainer/PanelContainer/Grid
onready var level : DraftLevel = $Level
onready var checkbox_dijkstra : CheckBox = $Debug/MarginContainer/PanelContainer/Grid/Dijkstra
onready var checkbox_astar : CheckBox = $Debug/MarginContainer/PanelContainer/Grid/AStar
onready var protagonist : Protagonist = $Protagonist

# Called when the node enters the scene tree for the first time.
func _ready():
	self.cells = level.get_accessible_cells()	
	
	var rect : Rect2 = level.tilemap_accessible_cells.get_used_rect()
	for i in range(0, self.cells.size()):
		grid_positions_to_points[cells[i]] = i
		astar.add_point(i, self.cells[i])
		
	for x in range(rect.position.x, rect.size.x):
		for y in range(rect.position.y, rect.size.y):
			if not grid_positions_to_points.has(Vector2(x, y)):
				continue
			var top = Vector2(x, y-1)
			var bottom = Vector2(x, y+1)
			var left = Vector2(x-1, y)
			var right = Vector2(x+1, y)
			if grid_positions_to_points.has(top):
				astar.connect_points(grid_positions_to_points[Vector2(x,y)], grid_positions_to_points[top])
			if grid_positions_to_points.has(bottom):
				astar.connect_points(grid_positions_to_points[Vector2(x,y)], grid_positions_to_points[bottom])
			if grid_positions_to_points.has(left):
				astar.connect_points(grid_positions_to_points[Vector2(x,y)], grid_positions_to_points[left])
			if grid_positions_to_points.has(right):
				astar.connect_points(grid_positions_to_points[Vector2(x,y)], grid_positions_to_points[right])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	self.position_grid = level.world_to_map(mouse_position * self.level_scale_factor)
	
	debug.get_node("MousePosition").text = String(mouse_position)
	debug.get_node("GridPosition").text = String(self.position_grid)
	debug.get_node("ProtagonistPositionWorld").text = String(self.protagonist.global_position)
	debug.get_node("ProtagonistPositionMap").text = String(level.world_to_map(protagonist.global_position * self.level_scale_factor))


func _unhandled_input(event: InputEvent):
	pass
	if not event is InputEventMouseButton:
		return
		
	if event.button_index != BUTTON_LEFT or not event.is_pressed():
		return
		
	if not self.position_grid in self.cells:
		return
	
	var src = level.world_to_map(self.protagonist.global_position * self.level_scale_factor)
		
	var target_position = level.map_to_world(self.position_grid) / self.level_scale_factor
	
	var path = []
	if checkbox_dijkstra.pressed:
		path = pathfinding.dijkstra(self.cells, src, self.position_grid)
	elif checkbox_astar.pressed:
		path = astar.get_point_path(self.grid_positions_to_points[src], self.grid_positions_to_points[self.position_grid])
	level.highlight_tiles(path)
	self.protagonist.move_along_path(path, self.level, self.level_scale_factor)
	

