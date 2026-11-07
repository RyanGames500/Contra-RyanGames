// --- 1. CONFIGURACIÓN INICIAL ---
draw_set_font(-1); 
draw_set_color(c_white);

// --- 2. ESTADO DE LOS JUGADORES EN COOP ---
if (global.game_mode == "coop" && !global.game_over_desplegado) {
    var _p1_vivo = false; 
    var _p2_vivo = false;
    
    // Chequeamos quién está en pantalla
    with(obj_player) { 
        if (player_ID == 1) _p1_vivo = true; 
        if (player_ID == 2) _p2_vivo = true; 
    }
    
    // Si uno muere pero el otro sigue, avisamos al que está esperando
    if (!_p1_vivo && _p2_vivo) {
        draw_text(20, 20, "P1 ELIMINADO: ESPERANDO A P2...");
    }
    if (!_p2_vivo && _p1_vivo) {
        draw_text(20, 20, "P2 ELIMINADO: ESPERANDO A P1...");
    }
}

// --- 3. PANTALLA DE GAME OVER (DERROTA TOTAL) ---
if (global.game_over_desplegado) {
    var _sw = display_get_gui_width();
    var _sh = display_get_gui_height();
    
    // Dibujamos un fondo negro semitransparente para que el texto resalte
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, _sw, _sh, false);
    draw_set_alpha(1);
    
    // Texto central
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle); // Centrado vertical también
    
    draw_set_color(c_red);
    draw_text_transformed(_sw/2, _sh/2 - 20, "FIN DEL JUEGO", 3, 3, 0);
    
    draw_set_color(c_white);
    draw_text(_sw/2, _sh/2 + 40, "PULSA ENTER PARA VOLVER AL INICIO");
    
    // Resetear alineación para no romper otros textos
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
