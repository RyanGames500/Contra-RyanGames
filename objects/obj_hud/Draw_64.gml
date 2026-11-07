// --- EVENTO DRAW GUI ---
var _gui_w = display_get_gui_width();

// 1. INICIALIZAR VARIABLES
var _p1_hp = 0;
var _p1_exists = false;
var _p2_hp = 0;
var _p2_exists = false;

// 2. BUSCAR A LOS JUGADORES
with(obj_player) {
    if (player_ID == 1) { _p1_hp = hp; _p1_exists = true; }
    if (player_ID == 2) { _p2_hp = hp; _p2_exists = true; }
}

// 3. LÓGICA DE PERSISTENCIA PARA P2
// Usamos una variable global o una variable del objeto hud para saber si el P2 entró al juego
if (_p2_exists) global.p2_joined = true; 

draw_set_font(-1); 
draw_set_valign(fa_middle);

// ==========================================
// JUGADOR 1 (Izquierda)
// ==========================================
var _x1 = 40;
var _y1 = 60;
draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(_x1, _y1 - 35, "PLAYER 1");

if (_p1_exists) {
    draw_sprite_ext(spr_hud_portrait_rayder, 0, _x1+10, _y1-15, 2.5, 2.5, 0, c_white, 1);
    draw_set_color(c_yellow);
    draw_text(_x1 + 60, _y1, "X " + string(_p1_hp)); 
} else {
    draw_set_color(c_red);
    draw_text(_x1, _y1, "DEAD");
}

// ==========================================
// JUGADOR 2 (Derecha)
// ==========================================
// Solo dibujamos si el Player 2 existe O si ya había entrado antes (global.p2_joined)
if (variable_global_exists("p2_joined") && global.p2_joined == true) {
    var _x2 = _gui_w - 40;
    var _y2 = 60;

    draw_set_halign(fa_right);
    draw_set_color(c_white);
    draw_text(_x2, _y2 - 35, "PLAYER 2");

    if (_p2_exists) {
        // P2 VIVO
        draw_sprite_ext(spr_hud_portrait_rayder, 0, _x2-10, _y2-15, -2.5, 2.5, 0, c_aqua, 1);
        draw_set_color(c_yellow);
        draw_text(_x2 - 60, _y2, string(_p2_hp) + " X");
    } else {
        // P2 MUERTO (Ahora sí saldrá DEAD en rojo)
        draw_set_color(c_red);
        draw_text(_x2, _y2, "DEAD");
    }
}