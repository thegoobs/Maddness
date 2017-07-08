local tile = {}
function tile:create(xpos, ypos)
	local t = {}
	t = display.newGroup()
	t.rect = display.newRoundedRect(t, 10 + 50*xpos, 50*ypos, 45, 45, 3)
	t.xpos = xpos
	t.ypos = ypos
	t.val = math.random(-5, 5)
	t.text = display.newText(t, t.val, 10 + 50*xpos, 50*ypos, "media/Bungee-Regular.ttf", 18)
	t.text:setFillColor(0,0,0)
	t.selected = false
	t.disabled = false
	t.destroyed = false

	t.alpha = 0
	transition.to(t, {time = 150, alpha = 1, y = 50})
	t:addEventListener("touch", tile)
	return t
end

function tile.adjacentCheck(t)
	if t.disabled == true then return false end
	if grid.lastTouched == nil then
		grid.lastTouched = t
		return true
	elseif math.abs(t.xpos - grid.lastTouched.xpos) + 
		   math.abs(t.ypos - grid.lastTouched.ypos) <= 1 then
		grid.lastTouched = t
		return true
	else
		return false
	end

end

function tile:touch(event)
	if game.state == "GAME" and 
	   event.target.selected == false and
	   self.adjacentCheck(event.target) == true and
	   event.target.disabled == false then

		if event.phase == "began" or event.phase == "moved" then
			touch:addPoint(event.target)
			event.target.rect:setFillColor(1,0,0)
			event.target.selected = true
			game.ctr = game.ctr + event.target.val
		end
	end


	if game.state == "GAME" and event.phase == "ended" then
		grid:compute()
	end
end


return tile