var _w = display_get_gui_width();
var _h = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(alpha);

// 1. Dibujar una banda negra de fondo para que resalte
draw_set_color(c_black);
draw_set_alpha(alpha * 0.7);
draw_rectangle(0, _h/2 - 60, _w, _h/2 + 60, false);
draw_set_alpha(alpha);

// 2. Texto Principal (con sombra)
draw_set_font(-1); // Usa tu fuente arcade
draw_text_transformed_color(_w/2 + x_offset + 3, _h/2 - 20 + 3, texto_grande, 2, 2, 0, c_black, c_black, c_black, c_black, alpha);
draw_text_transformed_color(_w/2 + x_offset, _h/2 - 20, texto_grande, 2, 2, 0, color_tema, color_tema, c_white, c_white, alpha);

// 3. Texto Secundario
draw_set_font(-1); // Una fuente más chica si tienes
draw_text_transformed_color(_w/2 - x_offset, _h/2 + 30, texto_pequeno, 1, 1, 0, c_white, c_white, c_gray, c_gray, alpha);

draw_set_alpha(1);