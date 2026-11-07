if (instance_exists(owner_boss) && instance_exists(owner_arm)) {
    // --- COLORES FIJOS (AZUL ELÉCTRICO) ---
    var _col1 = c_aqua; 
    var _col2 = c_aqua;
    var _col_glow = c_blue;
    
    // Si está preparando el golpe, que brillen más fuerte
    if (owner_arm.state == "preparando") {
        _col1 = c_white;
        _col2 = c_white;
    }

    // --- COORDENADAS BASE ---
    var _xb = owner_boss.x + (45 * owner_arm.side);
    var _yb = owner_boss.y + 20;
    var _xa = owner_arm.x;
    var _ya = owner_arm.y;

    // --- RAYO SUPERIOR (MÁS ARRIBA) ---
    var _y_sup = -12; // Mucho más arriba
    var _x1 = _xb;
    var _y1 = _yb + _y_sup;
    var _x2 = _xa;
    var _y2 = _ya + _y_sup;

    // --- RAYO INFERIOR (MÁS AL CENTRO Y ABAJO) ---
    var _x_inf_off = -15 * owner_arm.side; 
    var _y_inf_off = -5; // Más cerca del brazo
    var _x3 = _xb + _x_inf_off;
    var _y3 = _yb + _y_inf_off;
    var _x4 = _xa + _x_inf_off;
    var _y4 = _ya + _y_inf_off;

    // Vibración
    var _v = random_range(-1, 1);

    // DIBUJAR RAYO SUPERIOR (Azul)
    draw_line_width_color(_x1 + _v, _y1 + _v, _x2 + _v, _y2 + _v, 3, _col1, _col_glow);
    draw_line_width_color(_x1, _y1, _x2, _y2, 1, c_white, c_white);

    // DIBUJAR RAYO INFERIOR (Azul)
    draw_line_width_color(_x3 - _v, _y3 - _v, _x4 - _v, _y4 - _v, 3, _col2, _col_glow);
    draw_line_width_color(_x3, _y3, _x4, _y4, 1, c_white, c_white);

} else {
    // Si el brazo ya no existe, el rayo hace un "latigazo" y desaparece
    var _rand = random_range(-20, 20);
    draw_line_width_color(x1, y1, x1 + _rand, y1 + 50, 2, c_aqua, c_white);
    instance_destroy(); // Se destruye de una para que no ensucie la pantalla
}