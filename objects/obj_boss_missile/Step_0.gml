// 2. En el primer frame del Step, ya sabremos el valor de 'side'
if (!initialized) {
    direction = (side == -1) ? 135 : 45; 
    initialized = true;
}

// 3. Rotación visual (Lo que pediste)
image_angle = direction - 90; 

// 4. Buscar al jugador suavemente (Homing)
var _target = instance_nearest(x, y, obj_player);
if (_target != noone) {
    var _dir_to_player = point_direction(x, y, _target.x, _target.y);
    // Bajamos el multiplicador de 0.03 a 0.015 para que gire más abierto
	direction += angle_difference(_dir_to_player, direction) * 0.015;
}

// 5. Partículas
part_particles_create(global.ps, x, y, global.pt_smoke, 1);

// Reducir el tiempo de vida
tiempo_de_vida--;

// Si se acaba el tiempo o se sale mucho de la pantalla, se destruye
if (tiempo_de_vida <= 0) {
    instance_destroy();
}

// --- RESTRICCIÓN DE CÁMARA ---
// Obtenemos los límites de la vista actual
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

// Margen para que no toque exactamente el borde (ej: 16 píxeles)
var _margin = 32;

// Si el misil intenta salirse, lo obligamos a quedarse dentro
if (x < _cam_x + _margin) {
    x = _cam_x + _margin;
    hspeed = abs(hspeed); // Rebota a la derecha
}
if (x > _cam_x + _cam_w - _margin) {
    x = _cam_x + _cam_w - _margin;
    hspeed = -abs(hspeed); // Rebota a la izquierda
}
if (y < _cam_y + _margin) {
    y = _cam_y + _margin;
    vspeed = abs(vspeed); // Rebota hacia abajo
}
// Nota: En el borde inferior es mejor dejar que caiga o se destruya 
// si es que el suelo está fuera de cámara.