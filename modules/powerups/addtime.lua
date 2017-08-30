local addtime = {}

function addtime:activate(t) --t for tile
	game.dt = math.min(game.dt + 5, os.time())

	t:removeSelf()
	grid[t.xpos][t.ypos] = nil

	game:shake(hud.footer)
end

return addtime