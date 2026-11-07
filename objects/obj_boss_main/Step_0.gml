// --- 1. MOVIMIENTO SENOIDAL (Solo si ya terminó de entrar) ---
if (state != "derrotado" && state != "entrada" && instance_exists(base_core)) {
    var _intensidad = 1 + (1 - (base_core.hp / 5000)) * 2; 
    x += dsin(current_time * 0.05 * _intensidad) * (0.5 * _intensidad);
    y += dcos(current_time * 0.03 * _intensidad) * (0.3 * _intensidad);
}

// --- 2. ESTADO DE ENTRADA ---
if (state == "entrada") {
    // CAMBIO: y_objetivo ahora es 100 para que esté más abajo
    var _target_y = 100; 
    
    // CAMBIO: 0.05 es una velocidad más fluida que 0.01
    y = lerp(y, _target_y, 0.02); 
    
    if (abs(y - _target_y) < 1) {
        y = _target_y;
        state = "normal";
        with(obj_camera) { shake_magnitude = 10; shake_remain = 10; }
    }
    exit; // Bloquea el resto del Step hasta que llegue a su sitio
}

// --- 3. CLAMP (Limitar a la cámara) ---
// Solo se activa cuando NO está entrando y NO está derrotado
if (state != "derrotado" && state != "entrada") {
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_y = camera_get_view_y(view_camera[0]);
    var _cam_w = camera_get_view_width(view_camera[0]);
    var _cam_h = camera_get_view_height(view_camera[0]);
    
    var _margin_x = 100; 
    var _margin_y = 60; // Margen superior para que no toque el techo

    x = clamp(x, _cam_x + _margin_x, _cam_x + _cam_w - _margin_x);
    // Limitamos el movimiento a la mitad superior de la pantalla
    y = clamp(y, _cam_y + _margin_y, _cam_y + (_cam_h / 2));
}

// ... AQUÍ SIGUE EL RESTO DE TU CÓDIGO (Timers, Fases, etc.) ...

// --- ESTADO DE ENTRADA ---
if (state == "entrada") {
    // Baja suavemente desde el cielo
    y = lerp(y, y_objetivo, 0.01); 
    
    // Si ya casi llega a su posición, empieza la pelea
    if (abs(y - y_objetivo) < 1) {
        y = y_objetivo;
        state = "normal";
        // Sacudir cámara al aterrizar en el aire
        with(obj_camera) { shake_magnitude = 10; shake_remain = 10; }
    }
    exit; // No ejecuta el resto del código mientras entra
}

// --- 2. GESTIÓN DE TIMERS Y FASES DINÁMICAS ---
var _spd_fase = 1;
if (instance_exists(base_core)) {
    _spd_fase = 1 + (1 - (base_core.hp / 5000)); 
}
timer_fase += _spd_fase;

// --- 2.5 ACTIVACIÓN DE ARMAS CON AVISO ÉPICO ---
var _canones_activos = false;
var _misiles_activos = false;

if (instance_exists(base_core)) {
    
    // --- ALERTA DE CAÑONES (4000 HP) ---
    if (base_core.hp < 4500) {
        if (aviso_canones == false) {
            // EFECTO DE ENTRADA: Esto solo pasa un frame
            with(obj_camera) { shake_magnitude = 6; shake_remain = 6; } // Sacudir cámara
            audio_play_sound(snd_boss_alert, 10, false); // Pon un sonido de alarma o grito
            
            // Crear una ráfaga de chispas en los cañones para mostrar que se "encienden"
            with(obj_boss_cannon) {
                part_particles_create(global.ps, x, y, global.pt_spark, 20);
                image_blend = c_white; // Recuperan su color original
            }
            aviso_canones = true;
        }
        _canones_activos = true;
    }
    
    // --- ALERTA DE MISILES (3000 HP) ---
    if (base_core.hp < 4000) {
        if (aviso_misiles == false) {
            // EFECTO DE ENTRADA
            with(obj_camera) { shake_magnitude = 8; shake_remain = 8; }
            //audio_play_sound(snd_boss_powerup, 10, false);
            
            // Humo en los lanzadores al activarse
            with(obj_boss_launcher) {
                part_particles_create(global.ps, x, y, global.pt_smoke, 30);
                image_blend = c_white;
            }
            aviso_misiles = true;
			timer_aviso = 0;
        }
        _misiles_activos = true;
    }
}

// Pasamos la orden a los hijos (esto se mantiene igual)
with(obj_boss_cannon)   { can_attack = _canones_activos; }
with(obj_boss_launcher) { can_attack = _misiles_activos; }


// --- 3. CAMBIO DE FASE (Solo si hay vida) ---
if (timer_fase >= 300) {
    timer_fase = 0;
    fase_ataque++;
    if (fase_ataque > 3) fase_ataque = 1; 
    
    var _buff = (1 - (base_core.hp / 5000)) * 50; 

    switch(fase_ataque) {
        case 1: // BARRIDO
            if (instance_exists(top_gun1)) top_gun1.timer_ataque = 120 + _buff; 
            if (instance_exists(top_gun2)) top_gun2.timer_ataque = 60 + _buff;
            if (instance_exists(top_gun3)) top_gun3.timer_ataque = 0 + _buff;
            if (instance_exists(launcher_L)) launcher_L.timer = 200 + _buff;
            if (instance_exists(launcher_R)) launcher_R.timer = 0;
        break;
        case 2: // PINZA
            if (instance_exists(top_gun1)) top_gun1.timer_ataque = 100 + _buff;
            if (instance_exists(top_gun3)) top_gun3.timer_ataque = 100 + _buff;
            if (instance_exists(top_gun2)) top_gun2.timer_ataque = 0;
            if (instance_exists(launcher_L)) launcher_L.timer = 150 + _buff;
            if (instance_exists(launcher_R)) launcher_R.timer = 150 + _buff;
        break;
        case 3: // CAOS
            if (instance_exists(top_gun1)) top_gun1.timer_ataque = 150 + _buff;
            if (instance_exists(top_gun2)) top_gun2.timer_ataque = 150 + _buff;
            if (instance_exists(top_gun3)) top_gun3.timer_ataque = 150 + _buff;
            if (instance_exists(launcher_L)) launcher_L.timer = 50 + _buff;
            if (instance_exists(launcher_R)) launcher_R.timer = 150 + _buff;
        break;
    }
}

// --- 4. CONTROL DE FLUJO DE ESTADOS ---
switch(state) {
    case "normal":
        var _brazos_vivos = 0;
        with(obj_boss_arm) { if (state != "muerto") _brazos_vivos++; }
        if (_brazos_vivos == 0) {
            state = "vulnerable";
            timer_fase = 0;
        }
    break;

    case "vulnerable":
        if (!instance_exists(base_core)) {
            state = "derrotado";
        }
    break;
}

// --- 5. LÓGICA DE MUERTE FINAL ---
if (instance_exists(base_core)) {
    if (base_core.hp <= 0 && t2 == 0) {
        t2 = 1;
        state = "derrotado";
        sprite_index = spr_boss_destroy;
        timer_muerte = 0; 
        v_speed_caida = -2; // Pequeño saltito hacia arriba antes de caer (da realismo)
    }
}

if (state == "derrotado") {
    timer_muerte++;
    
    // FASE A: Suspenso (Vibración en el aire)
    if (timer_muerte < 60) { // Bajamos a 1 segundo de explosiones
        x += random_range(-4, 4);
        y += random_range(-2, 2);
        
        if (timer_muerte % 4 == 0) {
            var _rx = x + irandom_range(-80, 80);
            var _ry = y + irandom_range(-50, 50);
            part_particles_create(global.ps, _rx, _ry, global.pt_spark, 8);
        }
    } 
// --- FASE B: CAÍDA PESADA CON ESTELA DE DESTRUCCIÓN ---
    else {
        var _suelo_y = 480; // Ajusta a la altura de tu suelo
        
        if (y < _suelo_y) {
            v_speed_caida += 0.9; 
            y += v_speed_caida;
            //image_angle += 2; 

            // --- ESTELA DE DESTRUCCIÓN (PARTÍCULAS MIENTRAS CAE) ---
            // 1. Humo negro espeso (Sale de atrás del jefe)
            part_particles_create(global.ps, x + random_range(-40, 40), y + random_range(-20, 20), global.pt_smoke, 3);
            
            // 2. Chispas de cortocircuito (Salen disparadas en la caída)
            if (timer_muerte % 2 == 0) {
                part_particles_create(global.ps, x + random_range(-30, 30), y, global.pt_spark, 4);
            }

            // 3. Explosiones pequeñas aleatorias sobre el chasis mientras cae
            if (timer_muerte % 10 == 0) {
                var _ex = x + random_range(-60, 60);
                var _ey = y + random_range(-40, 40);
                part_particles_create(global.ps, _ex, _ey, global.pt_spark, 15);
                // Si tienes un sonido de explosión pequeña, ponlo aquí
                // audio_play_sound(snd_small_explosion, 5, false);
            }
        } 
        else {
            // --- IMPACTO CONTRA EL SUELO ---
            if (v_speed_caida != 0) {
                y = _suelo_y;
                v_speed_caida = 0;
                image_angle = 15;
                
                with(obj_camera) { shake_magnitude = 25; shake_remain = 25; }
                
                // Gran explosión final de impacto
                repeat(40) {
                    var _rx = x + irandom_range(-150, 150);
                    part_particles_create(global.ps, _rx, y + 20, global.pt_smoke, 10);
                    part_particles_create(global.ps, _rx, y + 20, global.pt_spark, 10);
                }
            }
        }
    }
    
     // Apagar hijos (Esto ya lo tenías, asegúrate que se ejecute una vez)
    with(obj_boss_cannon) { hp = 0; can_attack = false; }
    with(obj_boss_launcher) { hp = 0; can_attack = false; }
    exit; 
}

// Lógica de sprites para los lanzadores (image_index)
var _left_reloading = false;
var _right_reloading = false;
if (instance_exists(launcher_L)) { if (launcher_L.state == "reloading") _left_reloading = true; }
if (instance_exists(launcher_R)) { if (launcher_R.state == "reloading") _right_reloading = true; }

if (state != "derrotado") {
    if (_left_reloading && _right_reloading) image_index = 3;
    else if (_left_reloading) image_index = 1;
    else if (_right_reloading) image_index = 2;
    else image_index = 0;
}

