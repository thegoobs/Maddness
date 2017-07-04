local tile = {}
function tile:create(xpos, ypos)
	local t = {}
	t = display.newRoundedRect(10 + 50*xpos, 50*ypos + 50, 45, 45, 2)
	t.xpos = xpos
	t.ypos = ypos
	t.val = math.random(-5, 5)
	t.text = display.newText(t.val, 10 + 50*xpos, 50 + 50*ypos, "media/Bungee-Regular.ttf")
	t.text:setFillColor(0,0,0)
	t.selected = false

	t:addEventListener("touch", tile)
	return t
end

function tile:touch(event)
	print(event.phase)
	if event.target.selected == false then
		if event.phase == "began" or "moved" then
			touch:addPoint(event.target)
		end
		event.target:setFillColor(1,0,0)
		event.target.selected = true
		game.ctr = game.ctr + event.target.val
	end

	if event.phase == "ended" then
		grid:compute()
	end
end


return tile