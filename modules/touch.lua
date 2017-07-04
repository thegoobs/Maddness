local touch = {}
touch.points = {} --stores points

function touch:addPoint(t) --t for tile
	table.insert(touch.points, t)
end

return touch