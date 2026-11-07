if (spawn_activado) 
{
    var _total_enemigos = instance_number(obj_enemigo_spider);

    if (_total_enemigos < 4) 
    {
        timer_spawn++; // El contador siempre sube

        if (timer_spawn >= cadencia_spawn) 
        {
// --- DENTRO DEL IF DEL TIMER ---
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);

// SEGURIDAD: Si por alguna razón la cámara falla, forzamos valores reales
if (is_nan(_cam_x)) _cam_x = 0;
if (is_nan(_cam_w)) _cam_w = room_width;

var _cx = 0;
var _hsp_inicial = 0;
var _cy = 182; 

// Decidir lado (Izquierda o Derecha)
if (irandom(1) == 0) {
    _cx = _cam_x - 96; // Aumentamos un poco el margen para evitar bordes raros
    _hsp_inicial = 1.5; 
} else {
    _cx = _cam_x + _cam_w + 96;
    _hsp_inicial = -1.5; 
}

// VALIDACIÓN FINAL: Solo creamos si _cx es un número válido
if (!is_nan(_cx) && !is_infinity(_cx)) 
{
    // BLOQUEO DE AMONTONAMIENTO
    if (!collision_rectangle(_cx-20, _cy-20, _cx+20, _cy+20, obj_enemigo_spider, false, true)) 
    {
        var _en = instance_create_layer(_cx, _cy, "Instances", obj_enemigo_spider);
        
        // Verificamos que la instancia se creó bien antes de darle velocidad
        if (instance_exists(_en)) {
            _en.hsp = _hsp_inicial;
            timer_spawn = 0; 
        }
    }
}
        }
    }
}