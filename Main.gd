extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const pathfinding = preload("res://scripts/Pathfinding.gd")
var cells : Array = []
var grid_positions_to_points : Dictionary = {}
var position_mouse : Vector2 = Vector2(0, 0)
var position_grid : Vector2 = Vector2(0, 0)
var astar = AStar2D.new()
onready var debug : GridContainer = $Debug/Grid
onready var level : DraftLevel = $Level
onready var checkbox_dijkstra : CheckBox = $Debug/Grid/Dijkstra
onready var checkbox_astar : CheckBox = $Debug/Grid/AStar

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
	self.position_mouse = get_global_mouse_position()
	self.position_mouse.x = self.position_mouse.x 
	self.position_mouse.y = self.position_mouse.y
	var _position_grid = level.tilemap_accessible_cells.world_to_map(self.position_mouse * 2)
	if _position_grid == self.position_grid:
		return
	self.position_grid = _position_grid
	
	debug.get_node("MousePosition").text = "(" + String(position_mouse.x) + ", " + String(position_mouse.y) + ")"
	debug.get_node("GridPosition").text = "(" + String(position_grid.x) + ", " + String(position_grid.y) + ")"
	debug.get_node("ProtagonistPosition").text = "(" + String($Protagonist.position.x) + ", " + String($Protagonist.position.y) + ")"
	
	if not checkbox_astar.pressed:
		return
		
	var src = level.tilemap_accessible_cells.world_to_map($Protagonist.global_position * 2)
	if self.grid_positions_to_points.has(self.position_grid):
		var path = astar.get_point_path(self.grid_positions_to_points[src], self.grid_positions_to_points[self.position_grid])
		level.highlight_tiles(path)	
	
#	pass


func _unhandled_input(event: InputEvent):
	pass
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.is_pressed():
		return
	
	if not self.checkbox_dijkstra.pressed:
		return
		
	if not self.position_grid in self.cells:
		return		

	var target_position = level.tilemap_accessible_cells.map_to_world(self.position_grid) / 2

	var src = level.tilemap_accessible_cells.world_to_map($Protagonist.global_position * 2)
	var path = pathfinding.dijkstra(self.cells, src, self.position_grid)
	level.highlight_tiles(path)
	

