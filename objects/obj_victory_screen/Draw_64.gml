if(no_screen == true) exit;

var _w = display_get_gui_width();
var _h = display_get_gui_height();

// Fondo negro semitransparente
draw_set_alpha(alpha_fondo);
draw_set_color(c_black);
draw_rectangle(0, 0, _w, _h, false);
draw_set_alpha(1);

// Dibujar el texto principal (Sombra y luego Color)
draw_set_font(-1); // Tu fuente arcade
draw_set_halign(fa_center);

// Sombra
draw_text_transformed_color(_w/2 + 4, y_texto + 4, texto_victoria, 2, 2, 0, c_black, c_black, c_black, c_black, 0.5);
// Texto (Dorado/Amarillo)
draw_text_transformed_color(_w/2, y_texto, texto_victoria, 2, 2, 0, c_yellow, c_yellow, c_orange, c_orange, 1);

// Dibujar sub-texto (Letras que aparecen poco a poco)
draw_text_transformed_color(_w/2, y_texto + 80, letras_actuales, 1, 1, 0, c_white, c_white, c_gray, c_gray, 1);

// Mensaje de "Presiona Enter" parpadeando
if (timer_letras >= string_length(sub_texto)) {
    if (current_time % 1000 < 500) {
        draw_text(_w/2, _h - 100, "PRESIONA [ENTER] PARA CONTINUAR");
    }
}