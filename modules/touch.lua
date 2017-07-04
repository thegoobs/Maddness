local touch = {}
touch.points = {} --stores points

function touch:addPoint(xpos, ypos)
	table.insert(touch.points, {x=xpos, y=ypos})
end

return touch