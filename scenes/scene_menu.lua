local scene = composer.newScene()

function addButtons()
    endless = widget.newButton({
        id = "endless",
        label = "Play",
        x = display.contentCenterX - 50,
        y = 200,
        labelYOffset = 18,

        shape = "roundedRect",
        width = 50,
        height = 50,
        radius = 3,
        fillColor = {default={unpack(game.theme.main)}, over={unpack(game.theme.sub)}},

        font = "media/Bungee-Regular.ttf",
        fontSize = 8,
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
        })    
    endless.img = display.newImage("media/play.png", endless.x, endless.y - 4)
    endless.img:scale(0.5,0.5)
    endless.img:setFillColor(unpack(game.theme.sub))

    if howTo == nil then
        howTo = display.newRoundedRect(display.contentWidth - 40, display.contentHeight - 40, 25, 25, 3)
        howTo.label = display.newText("?", howTo.x, howTo.y + 1, "media/Bungee-Regular.ttf", 16)
        howTo:setFillColor(unpack(game.theme.main))
        howTo.label:setFillColor(unpack(game.theme.sub))
        howTo.id = "howTo"
        howTo:addEventListener("touch", buttonPress)
    end

    themeSelect = widget.newButton({
        id = "themeSelect",
        x = display.contentCenterX + 50,
        y = 200,

        shape = "roundedRect",
        width = 50,
        height = 50,
        radius = 3,
        fillColor = {default={unpack(game.theme.main)}, over={unpack(game.theme.sub)}},

        font = "media/Bungee-Regular.ttf",
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
        })
    themeSelect.img = display.newImage("media/color.png", themeSelect.x, themeSelect.y)
    themeSelect.img:scale(0.5,0.5)
    themeSelect.img:setFillColor(unpack(game.theme.sub))

    game.save = file:load("savedata")
    if game.save ~= nil then
        endless:setLabel("New Game")
        continue = widget.newButton({
        id = "continue",
        label = "Continue",
        x = display.contentCenterX,
        y = 200,
        labelYOffset = 18,

        shape = "roundedRect",
        width = 50,
        height = 50,
        radius = 3,
        fillColor = {default={unpack(game.theme.main)}, over={unpack(game.theme.sub)}},

        font = "media/Bungee-Regular.ttf",
        fontSize = 8,
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
        })
        continue.img = display.newImage("media/save.png", continue.x, continue.y - 4)
        continue.img:scale(0.5,0.5)
        continue.img:setFillColor(unpack(game.theme.sub))

        themeSelect.x = display.contentCenterX + 75
        themeSelect.img.x = themeSelect.x

        if themeCtr ~= nil then
            themeCtr.x = themeSelect.x
        end


        endless.x = display.contentCenterX - 75
        endless.img.x = endless.x
    end

    endless:addEventListener("touch", buttonPress)
    themeSelect:addEventListener("touch", buttonPress)
    if game.save then continue:addEventListener("touch", buttonPress) end

    g:insert(endless)
    g:insert(endless.img)
    g:insert(themeSelect)
    g:insert(themeSelect.img)
    if game.save ~= nil then
        g:insert(continue)
        g:insert(continue.img)
    end
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
function buttonPress(event)
    if event.phase == "ended" then
        sound:play("button")
        if event.target.id == "endless" then
            game.mode = "endless"
            timer.performWithDelay(100, function()
                composer.gotoScene("scenes.scene_game")
            end)
            endless:removeEventListener("touch", buttonPress)
            return true

        elseif event.target.id == "continue" then
            game.mode = "continue"
            timer.performWithDelay(100, function() composer.gotoScene("scenes.scene_game") end)
            endless:removeEventListener("touch", buttonPress)
            continue:removeEventListener("touch", buttonPress)

        elseif event.target.id == "howTo" and (game.state == "GAME" or game.state == "NOT GAME") then
            game:tutorial()

        elseif event.target.id == "themeSelect" then
            if game.best - ((game.theme_index + 2) * 1000) + 1000 >= 0 then
                game.theme_index = ((game.theme_index + 1) % #theme)
                game.theme = theme[game.theme_index + 1]

                if theme[game.theme_index + 1].used == false then
                    theme[game.theme_index + 1].used = true
                    reward:newTheme()
                end
            else
                game.theme_index = 0
                game.theme = theme[1]
                game:shake(themeSelect.img)

                --show what score is required
                nextTheme.text = "Next theme at: " .. math.floor(game.best / 1000) * 1000 + 1000
                game:shake(nextTheme)
            end
                    
            if themeCtr ~= nil then
                if themeCtr.text ~= nil then
                    themeCtr:removeSelf()
                    themeCtr = nil
                end
            end

            --set the color of the scene again (game will load correctly)
            timer.performWithDelay(10, function() --weird things happen
                bg:setFillColor(unpack(game.theme.bg))

                title:setFillColor(unpack(game.theme.main))
                titleAdd:setFillColor(unpack(game.theme.sub))
                subtitle:setFillColor(unpack(game.theme.main))
                highscore:setFillColor(unpack(game.theme.main))
                nextTheme:setFillColor(unpack(game.theme.main))

                endless:removeEventListener( "touch", buttonPress )
                themeSelect:removeEventListener( "touch", buttonPress )
                howTo:removeEventListener("touch", buttonPress)
                if game.save ~= nil then
                    continue:removeEventListener( "touch", buttonPress )
                end

                endless:removeSelf()
                endless.img:removeSelf()
                endless.img = nil
                endless = nil

                themeSelect:removeSelf()
                themeSelect.img:removeSelf()
                themeSelect.img = nil
                themeSelect = nil

                howTo:removeSelf()
                howTo.label:removeSelf()
                howTo.label = nil
                howTo = nil

                if game.save ~= nil then
                    continue:removeSelf()
                    continue.img:removeSelf()
                    continue.img = nil
                    continue = nil
                end

                addButtons()

                themeCtr = display.newText(g, "", themeSelect.x, themeSelect.y + 35, "media/Bungee-Regular.ttf", 12)
                themeCtr:setFillColor(unpack(game.theme.main))
                themeCtr.text = game.theme_index + 1 .. "/" .. #theme
                themeCtr:setFillColor(unpack(game.theme.main))
                g:insert(themeCtr)
            end)
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view


    game.save = file:load("MaddnessGameInfo")
    if game.save ~= nil then
        game.firstTime = game.save.firstTime
        game.mute = game.save.mute
        game.theme_index = game.save.theme_index
        for i = 1, #theme do
            theme[i].used = game.save.theme[i]
        end
    else
        game.firstTime = false
    end
    if game.theme_index == nil then
        game.theme_index = 0
    end
    game.theme = theme[game.theme_index + 1]
    game.newTheme = math.floor(game.score / 5000) + 1

    g = display.newGroup()
    bg = display.newRect(g, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(unpack(game.theme.bg))

    title = display.newText(g, "M          ness", display.contentCenterX, 100, "media/Bungee-Regular.ttf" , 48)
    titleAdd = display.newText(g, "add", display.contentCenterX - 44, 100, "media/Bungee-Regular.ttf" , 48)
    subtitle = display.newText(g, "Add, Swipe, Win", display.contentCenterX, 135, "media/Bungee-Regular.ttf" , 16)
    highscore = display.newText(g, "", display.contentCenterX, 265, "media/Bungee-Regular.ttf" , 16)
    nextTheme = display.newText(g, "", display.contentCenterX, 280, "media/Bungee-Regular.ttf" , 16)
    title:setFillColor(unpack(game.theme.main))
    titleAdd:setFillColor(unpack(game.theme.sub))
    subtitle:setFillColor(unpack(game.theme.main))
    highscore:setFillColor(unpack(game.theme.main))

    local s = {}
    if firstLoad == true then
        s = file:load("MaddnessGameInfo")
        firstLoad = false
    end

    if s ~= nil then
        if s.highscore ~= nil then
            game.best = s.highscore
        end
    end

    if game.best > 0 then
        highscore.text = "Highscore: " .. game.best
    end

    addButtons()

    sceneGroup:insert(g)

    game.mode = nil --haven't picked it yet!
end
 

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end
 

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        composer.removeScene("scenes.scene_menu")
    end
end
 

function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    file:saveStats()
    g:removeSelf()

    g = nil
end
 
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene