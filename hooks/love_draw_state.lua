if in_astate("future", 0) then
    statecaught = true

	love.graphics.setColor(12,12,12,255)
	love.graphics.rectangle("fill", 8, 16, love.graphics.getWidth()-136, love.graphics.getHeight()-24)
	love.graphics.setColor(255,255,255,255)

    love.graphics.setScissor(SPRITE_PICKER_OFFSET_X, SPRITE_PICKER_OFFSET_Y, love.graphics.getWidth()-136-188, love.graphics.getHeight() - 24 - 8)

    local entity = entitydata[SPRITE_PICKER_ENTITY_ID]

    local current_tile_id = entity.p1

    if entity.t == 18 then
        -- Terminal
        current_tile_id = entity.p1 + 16
        if entity.p1 == 1 then
            current_tile_id = 16
        elseif entity.p1 == 0 then
            current_tile_id = 17
        end
    elseif entity.t == 10 then
        -- Checkpoint
        current_tile_id = entity.p1 + 20
    elseif entity.t == 5 then
        -- Flip token
        current_tile_id = entity.p1 + 68
    end

    for i = 0, (tilesets["sprites.png"].tiles_width * tilesets["sprites.png"].tiles_height) - 1 do
        local x = SPRITE_PICKER_OFFSET_X + (i % 12) * 32
        local y = SPRITE_PICKER_SCROLL_OFFSET + SPRITE_PICKER_OFFSET_Y + math.floor(i / 12) * 32
        if mouseon(x, y, 32, 32) then
            tile_id = i
            love.graphics.setColor(255,255,255,64)
            love.graphics.rectangle("fill", x, y, 32, 32)
        end
        love.graphics.setColor(255,255,255)
        love.graphics.draw(tilesets["sprites.png"].white_img, tilesets["sprites.png"].tiles[i], x, y)
        if i == current_tile_id then
            love.graphics.setColor(0,255,255,128)
            love.graphics.rectangle("line", x, y, 32, 32)
        end
    end
    love.graphics.setScissor()

    if entity.t == 18 or entity.t == 10 then
        -- Terminal and checkpoint
        v6_setcol(4)
    elseif entity.t == 5 then
        -- Flip tokens
        v6_setcol(entity.p2)
    end


    love.graphics.draw(tilesets["sprites.png"].white_img, tilesets["sprites.png"].tiles[current_tile_id], 640, (love.graphics.getHeight() / 2) - 32, 0, 2, 2)

    love.graphics.setColor(255, 255, 255)
    ved_print(tile_id, love.graphics.getWidth()-24, love.graphics.getHeight()-8)


	rbutton({L.RETURN, "b"}, 0, nil, true)

    if nodialog and love.mouse.isDown("l") and not mousepressed then
        if onrbutton(0, nil, true) then
            -- Return
            tostate(1, true)
            mousepressed = true
            return
        end
    end
end
