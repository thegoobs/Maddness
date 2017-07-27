local touch = {}
touch.points = {} --stores tiles that have been touched
touch.powerups = {} --stores powerups that have been touched

function touch:addPoint(t) --t for tile
	if t.powerup == false or t.powerup == "evenOdd" then
		table.insert(touch.points, t)
	elseif t.powerup ~= "evenOdd" then
		table.insert(touch.points, t) --add in regular tile table for animations sake
		table.insert(touch.powerups, t)
	end
end

return touch