extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# grid: Array of Vector2
static func dijkstra(grid: Array, src: Vector2, dest: Vector2):

	var reference_table = {}
	var unvisited = grid.size()

	for i in range(0, grid.size()):
		# unvisited.append(Vector2(grid[i].x, grid[i].y))
		reference_table[Vector2(grid[i].x, grid[i].y)] = {'previous': null, 'distance': INF, 'visited': false}
		if grid[i].x == src.x and grid[i].y == src.y:
			reference_table[Vector2(grid[i].x, grid[i].y)] = {'previous': null, 'distance': 0, 'visited': false}
	
	# var start = src
	
	while unvisited > 0:
		var d = INF
		var current = null
		for v in reference_table.keys():
			if reference_table[v]['visited']:
				continue
			if reference_table[v]['distance'] < d:
				current = v
				d = reference_table[v]['distance']
#			if reference_table[v]['distance'] == d and current:
#				if v.distance_to(dest) < current.distance_to(dest):
#					current = v
		if current == dest:
			var path = [dest]
			while dest != src:
				var prev = reference_table[dest]['previous']
				path.append(prev)
				dest = prev
			return path
		if current == null:
			return[]
			
		unvisited -= 1
		
		reference_table[current]['visited'] = true
#		src = next
		# find neighbours
		var neighbours = []
		var top = Vector2(current.x, current.y + 1)
		var bottom = Vector2(current.x, current.y - 1)
		var right = Vector2(current.x + 1, current.y)
		var left = Vector2(current.x - 1, current.y)
		if reference_table.has(top):
			if not reference_table[top]['visited']: neighbours.append(top)
		if reference_table.has(bottom):
			if not reference_table[bottom]['visited']: neighbours.append(bottom)
		if reference_table.has(right):
			if not reference_table[right]['visited']: neighbours.append(right)
		if reference_table.has(left):
			if not reference_table[left]['visited']: neighbours.append(left)
			
	
		
		for n in neighbours:
			d = reference_table[current]['distance'] + 1
			if d < reference_table[n]['distance']:
				reference_table[n]['distance'] = d
				reference_table[n]['previous'] = Vector2(current.x, current.y)
		
	return []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
