#include <gb/gb.h>
#include <stdint.h>
#include "global.h"
#include "tiles.h"
#include "map.h"

void gameScreenInit() {
    // Load Background tiles and then map
    //set_bkg_palette( 0, 1, Logo_palettes);
    set_bkg_data(0, TileLen, Tile);
    set_bkg_tiles(0, 0, MapWidth, MapHeight, Map);

    // Turn the background map on to make it visible
    SHOW_BKG;

    DISPLAY_ON;
}

void gameScreenUpdate() {
    UPDATE_KEYS();

    if (KEY_TICKED(J_START)) {
         game_state = GS_END;
    }
}