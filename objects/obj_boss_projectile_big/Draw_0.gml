// 1. Dibujar la bala
draw_self();

// 2. Dibujar sombra de advertencia en el suelo (opcional)
var _ground_y = room_height - 32; // Ajusta a la altura de tu suelo
var _scale = clamp(1 - (abs(y - _ground_y) / 500), 0.2, 1.5);

draw_sprite_ext(spr_select_target, 0, x, _ground_y, _scale, _scale * 0.5, 0, c_red, 0.5);