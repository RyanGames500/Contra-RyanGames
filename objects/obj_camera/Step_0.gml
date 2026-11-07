// 1. Encontrar a los jugadores
var _p1 = noone;
var _p2 = noone;
with(obj_player) {
    if (player_ID == 1) _p1 = id;
    if (player_ID == 2) _p2 = id;
}

// 2. Lógica de posición (CORREGIDA)
var _target_x = x; // Por defecto, quedarse donde está

if (instance_exists(_p1) && instance_exists(_p2)) {
    var _mid_x = (_p1.x + _p2.x) / 2;
    var _lagger_x = min(_p1.x, _p2.x);
    var _left_boundary = x - (cam_width / 2) + 100; 
    
    // Solo avanzamos si el de atrás no está atrapado
    if (_lagger_x > _left_boundary) {
        _target_x = _mid_x;
    }
} 
else if (instance_exists(_p1)) { 
    _target_x = _p1.x; 
}
else if (instance_exists(_p2)) { 
    _target_x = _p2.x; 
}

// APLICAR SUAVIZADO EN X (Para evitar el salto brusco al morir uno)
// 0.1 es una velocidad rápida pero fluida. Ajusta a tu gusto.
x = lerp(x, _target_x, 0.1);

// 3. Bloqueo de retroceso "Contra"
if (x > max_x) max_x = x;
x = max(x, max_x);

// 4. Suavizado Vertical (Versión Zona Muerta - No necesita variables del jugador)
var _target_y = y;

if (instance_exists(_p1) || instance_exists(_p2)) {
    // Tomamos la posición Y promedio de los jugadores que existan
    var _avg_y = 0;
    var _c = 0;
    if (instance_exists(_p1)) { _avg_y += _p1.y; _c++; }
    if (instance_exists(_p2)) { _avg_y += _p2.y; _c++; }
    _avg_y = _avg_y / _c;

    // --- EL TRUCO ---
    // Solo movemos la cámara si el jugador se aleja más de 50 píxeles del centro actual
    // Esto crea un "colchón" para que el salto no mueva la cámara
    if (abs(_avg_y - 40 - y) > 70) {
        _target_y = _avg_y - 40;
    } else {
        _target_y = y; // Mantener la altura actual
    }
}

// Lerp muy suave para que la cámara no vibre
y = lerp(y, _target_y, 0.05);

// 5. Límites finales de la Room
x = clamp(x, cam_width/2, room_width - cam_width/2);
y = clamp(y, cam_height/2, room_height - cam_height/2);

// 6. BLOQUEO FÍSICO (Para eliminar el Jitter)
// Usamos variables locales para que el clamp sea exacto al píxel de la cámara
var _vw_left = x - cam_width/2;
var _vw_right = x + cam_width/2;

with(obj_player) {
    // El secreto: Si el jugador se sale, lo movemos a la fuerza ANTES de dibujar
    if (x < _vw_left + 16) x = _vw_left + 16;
    if (x > _vw_right - 16) x = _vw_right - 16;
}

// 7. RENDERIZADO (Shake y redondeo a floor para evitar píxeles partidos)
var _shx = random_range(-shake_remain, shake_remain);
var _shy = random_range(-shake_remain, shake_remain);
shake_remain = max(0, shake_remain - 0.4);

// Usamos floor para que la cámara siempre esté en coordenadas enteras
var _final_x = floor(x - cam_width/2 + _shx);
var _final_y = floor(y - cam_height/2 + _shy);

camera_set_view_pos(view_camera[0], _final_x, _final_y);