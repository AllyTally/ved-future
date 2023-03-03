local x, y, button = ...

if (button == "l") and in_astate("future", 0) and not mousepressed and nodialog then
    local mouse_x = math.floor((x - SPRITE_PICKER_OFFSET_X) / 32)
    local mouse_y = math.floor((y - (SPRITE_PICKER_SCROLL_OFFSET + SPRITE_PICKER_OFFSET_Y)) / 32)

    local sprites_count = tilesets["sprites.png"].tiles_width * tilesets["sprites.png"].tiles_height

    if mouse_x >= 0 and mouse_x < 12 then
        local tile_id = mouse_x + mouse_y * 12
        if tile_id < sprites_count then
            mousepressed = true
            local entity = entitydata[SPRITE_PICKER_ENTITY_ID]
            local offset = 0
            if entity.t == 18 then
                -- Terminal
                offset = 16
                if tile_id == 17 then
                    entity.p1 = 0
                    return
                elseif tile_id == 16 then
                    entity.p1 = 1
                    return
                end
            elseif entity.t == 10 then
                -- Checkpoint
                offset = 20
            elseif entity.t == 5 then
                -- Flip token
                offset = 68
            end
            entity.p1 = tile_id - offset
            --tostate(1, true)
            return
        end
    end
end
