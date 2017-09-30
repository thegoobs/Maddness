local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
function buttonPress(event)
    if event.phase == "ended" then
        sound:play("button")
        if event.target.id == "endless" then
            game.mode = "endless"
            timer.performWithDelay(100, function() composer.gotoScene("scenes.scene_game") end)
            endless:removeEventListener("touch", buttonPress)
            return true
        elseif event.target.id == "continue" then
            game.mode = "continue"
            timer.performWithDelay(100, function() composer.gotoScene("scenes.scene_game") end)
            endless:removeEventListener("touch", buttonPress)
            continue:removeEventListener("touch", buttonPress)
        elseif event.target.id == "themeSelect" then
            game.theme_index = ((game.theme_index + 1) % theme.max)
            game.theme = theme[game.theme_index + 1]

            --set the color of the scene again (game will load correctly)
            timer.performWithDelay(10, function() --weird things happen
                bg:setFillColor(unpack(game.theme.bg))

                title:setFillColor(unpack(game.theme.main))
                subtitle:setFillColor(unpack(game.theme.main))
                highscore:setFillColor(unpack(game.theme.main))
                

                endless:setFillColor(unpack(game.theme.main))
                endless.img:setFillColor(unpack(game.theme.sub))
                
                themeSelect:setFillColor(unpack(game.theme.main))
                themeSelect.img:setFillColor(unpack(game.theme.sub))

                if game.save ~= nil then
                    continue:setFillColor(unpack(game.theme.main))
                    continue.img:setFillColor(unpack(game.theme.sub))
                end

            end)
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view

    g = display.newGroup()
    bg = display.newRect(g, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(unpack(game.theme.bg))

    title = display.newText(g, "Nuffins", display.contentCenterX, 100, "media/Bungee-Regular.ttf" , 48)
    subtitle = display.newText(g, "Swipe, add, win", display.contentCenterX, 135, "media/Bungee-Regular.ttf" , 16)
    highscore = display.newText(g, "", display.contentCenterX, 250, "media/Bungee-Regular.ttf" , 16)
    title:setFillColor(unpack(game.theme.main))
    subtitle:setFillColor(unpack(game.theme.main))
    highscore:setFillColor(unpack(game.theme.main))

    local s = {}
    if firstLoad == true then
        s = file:load("NuffinsGameInfo")
        firstLoad = false
    end

    if s ~= nil then
        if s.highscore ~= nil then
            game.mute = s.mute
            game.best = s.highscore
        end
    end

    if game.best > 0 then
        highscore.text = "Highscore: " .. game.best
    end

--BUTTONS
    endless = widget.newButton({
        id = "endless",
        x = display.contentCenterX - 50,
        y = 200,

        shape = "roundedRect",
        width = 50,
        height = 50,
        radius = 3,
        fillColor = {default={unpack(game.theme.main)}, over={unpack(game.theme.sub)}},

        font = "media/Bungee-Regular.ttf",
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
        })
    endless.img = display.newImage("media/play.png", endless.x, endless.y)
    endless.img:scale(0.5,0.5)
    endless.img:setFillColor(unpack(game.theme.sub))

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
        continue = widget.newButton({
        id = "continue",
        x = display.contentCenterX,
        y = 200,

        shape = "roundedRect",
        width = 50,
        height = 50,
        radius = 3,
        fillColor = {default={unpack(game.theme.main)}, over={unpack(game.theme.sub)}},

        font = "media/Bungee-Regular.ttf",
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
        })
        continue.img = display.newImage("media/save.png", continue.x, continue.y)
        continue.img:scale(0.5,0.5)
        continue.img:setFillColor(unpack(game.theme.sub))

        themeSelect.x = display.contentCenterX + 75
        themeSelect.img.x = themeSelect.x

        endless.x = display.contentCenterX - 75
        endless.img.x = endless.x


    end
    
    -- timeattack = widget.newButton({
    --     id = "timeattack",
    --     label = "Time Attack",
    --     x = display.contentCenterX,
    --     y = 250,

    --     shape = "roundedRect",
    --     width = 200,
    --     height = 35,
    --     radius = 3,
    --     fillColor = {default={unpack(game.theme.main)}, over={unpack(game.theme.sub)}},

    --     font = "media/Bungee-Regular.ttf",
    --     labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
    --     })

    g:insert(endless)
    g:insert(endless.img)
    g:insert(themeSelect)
    g:insert(themeSelect.img)
    if game.save ~= nil then
        g:insert(continue)
        g:insert(continue.img)
    end
    -- g:insert(timeattack)

    sceneGroup:insert(g)

    game.mode = nil --haven't picked it yet!

    endless:addEventListener("touch", buttonPress)
    themeSelect:addEventListener("touch", buttonPress)
    if game.save then continue:addEventListener("touch", buttonPress) end
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
    print("kill me")
    g:removeSelf()

    g = nil
end
 
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene