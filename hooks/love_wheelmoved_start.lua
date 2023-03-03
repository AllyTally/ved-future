local xm, ym = ...

if in_astate("future", 0) and nodialog then

    local tile_count = (tilesets["sprites.png"].tiles_width * tilesets["sprites.png"].tiles_height)
    local tile_height = math.ceil(tile_count / 12) * 32
    local upper_bound = tile_height - (love.graphics.getHeight() - 24 - 8)

    SPRITE_PICKER_SCROLL_OFFSET = -math.min(math.max(0, -(SPRITE_PICKER_SCROLL_OFFSET + (ym * s.mousescrollingspeed))), upper_bound)
end
