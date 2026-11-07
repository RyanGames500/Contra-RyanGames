// 1. POSICIONAMIENTO Y MOVIMIENTO
if (state != "muerto") {
    if (state == "idle") {
        x = owner.x + (47 * side);
        var _offset = (side == 1) ? 0 : 90; 
        var _hover = dsin((current_time * 0.1) + _offset) * 4; 
        y = owner.y + 23 + _hover;
    }

    if (state == "preparando") {
        x = owner.x + (47 * side);
        y = owner.y + 23; 
    }
}

// 2. LÓGICA DE GIRO Y DAÑO
image_xscale = -side;

// NUEVA LÓGICA DE MUERTE
if (hp <= 0 && state != "muerto") {
    state = "muerto";
    sprite_index = spr_brazos_destroy; 
    image_index = 0;
    image_speed = 1;

    // Impulso inicial de explosión (lo saca del piso si estaba ahí)
    vspeed = -5; 
    hspeed = side * 2; 
    

}

// Efecto de HIT (solo si no ha muerto)
if (state != "muerto") {
    image_blend = (hit == true) ? c_red : c_white;
}

// --- DETECCIÓN DE JUGADOR ---
var _target = instance_nearest(x, y, obj_player);
if (_target == noone) exit;

// 3. LÓGICA DE ESTADOS
switch(state) {
   case "idle":
        if (abs(x - _target.x) < 40) { 
            timer_ataque++;
            if (timer_ataque > 30) { state = "preparando"; timer_ataque = 0; }
        } else { timer_ataque = 0; }
    break;

    case "preparando":
        x += random_range(-1, 1);
        timer_ataque++;
        if (timer_ataque > 15) state = "caida";
    break;

    case "caida":
        y += 12; 
        if (y >= _target.y + 10) { 
            state = "impacto";
            timer_ataque = 0;
            with(obj_camera) { shake_magnitude = 6; shake_remain = 6; }
			if(global.sfx==true){audio_play_sound(snd_boss_wall_impact,1,0)}
        }
    break;

    case "impacto":
        timer_ataque++;
        x += random_range(-0.5, 0.5); 
        if (timer_ataque > 40) state = "subiendo";
    break;

    case "subiendo":
        y -= 3; 
        if (y <= owner.y + 23) { state = "idle"; timer_ataque = 0; }
    break;

case "muerto":
        // --- EL REACOMODO MAGNÉTICO (Igual que antes) ---
        hspeed = lerp(hspeed, 0, 0.05);
        vspeed = lerp(vspeed, 0, 0.05);
        var _tx = owner.x + (47 * side);
        var _ty = owner.y + 23;

        if (abs(vspeed) < 0.5) {
            x = lerp(x, _tx, 0.04);
            y = lerp(y, _ty, 0.04);
        }

        // --- CONTROL DE ANIMACIÓN DE 2 VUELTAS ---
        // Si la animación llega al final de la primera vuelta...
        if (image_index >= image_number - 1) {
            if (muerte_loops < 3) { 
                // Si es la primera vez que termina, reiniciamos el frame a 0
                image_index = 0;
                muerte_loops += 1; // Ya completó una vuelta
            } else {
                // Si ya completó las vueltas necesarias, lo clavamos en el frame 3
                image_speed = 0;
                image_index = 3;
                image_blend = c_dkgray; 
            }
        }

        // Parpadeo de error
        image_alpha = (irandom(100) > 90) ? random_range(0.5, 1) : 1;
    break;
}