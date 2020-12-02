class_name DraftLevel

extends Node2D


# Declare member variables here. Examples:
var tilemap_highlight : TileMap = null
var cell_index_highlight : int = 0
var tilemap_accessible_cells : TileMap = null

func set_tilemap_highlight(tilemap: TileMap):
	self.tilemap_highlight = tilemap

func highlight_tile(tile: Vector2):
	self.set_tilemap_highlight.clear()
	self.set_tilemap_highlight.set_cellv(tile, cell_index_highlight)

func highlight_tiles(tiles: Array):
	self.tilemap_highlight.clear()
	for t in tiles:
		self.tilemap_highlight.set_cellv(t, cell_index_highlight)

func get_accessible_cells() -> Array:
	return self.tilemap_accessible_cells.get_used_cells()

func world_to_map(position_world: Vector2) -> Vector2: 
	return self.tilemap_accessible_cells.world_to_map(position_world)

func map_to_world(position_map: Vector2) -> Vector2:
	return self.tilemap_accessible_cells.map_to_world(position_map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
