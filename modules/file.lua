--HUGE thank you to Rob Miracle and his tutorial on how to save game data in Corona SDK.
-- URL: http://omnigeek.robmiracle.com/2012/02/23/need-to-save-your-game-data-in-corona-sdk-check-out-this-little-bit-of-code/

local file = {}

function file:save(filename)
	--items needed to be saved: current grid and score
	local t = {}
	t.score = game.score

	t.grid = {}
	for i = 1, game.columns do
		t.grid[i] = {}
		for j = 1, game.rows do
			t.grid[i][j] = grid[i][j]
		end
	end

	local path = system.pathForFile( filename, system.DocumentsDirectory)
	local file = io.open(path, "w")

	if file then
		local contents = json.encode(t)
		file:write( contents )
		io.close( file )
	end
end

function file:saveStats()
	local path = system.pathForFile("MaddnessGameInfo", system.DocumentsDirectory) --holds mute and highscore
	local file = io.open(path, "w")

	local s = {}
	s.highscore = game.best
	s.mute = game.mute
	s.theme_index = game.theme_index
	s.firstTime = game.firstTime
	
	--get whether themes have been used
	s.theme = {}
	for i = 1, #theme do
		s.theme[i] = theme[i].used
	end
	if file then
		local contents = json.encode(s)
		file:write(contents)
		io.close(file)
	end
end

function file:load(filename)
	if filename == "savedata" then
		local path = system.pathForFile( filename, system.DocumentsDirectory)
		local contents = ""
		local t = {}
		local file = io.open( path, "r" )
		
		if file then
			-- read all contents of file into a string
			local contents = file:read( "*a" )
			t = json.decode(contents)
			io.close( file )
			if t ~= nil then
				if t.grid[1][1] ~= nil then
					return t
				else
					return nil
				end
			end
		end
	elseif filename == "MaddnessGameInfo" then
		local path = system.pathForFile( filename, system.DocumentsDirectory)
		local contents = ""
		local t = {}
		local file = io.open( path, "r" )
		
		if file then
			-- read all contents of file into a string
			local contents = file:read( "*a" )
			t = json.decode(contents)
			io.close( file )
			if t ~= nil then
				if t.best ~= 0 then
					return t
				else
					return nil
				end
			end
		end
	end

	return nil
end

function file:remove(filename)
	local path = system.pathForFile( filename, system.DocumentsDirectory)
	os.remove(path)
	file:load(filename)
end


return file