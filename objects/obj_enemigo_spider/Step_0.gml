
// Solo se mueve y detecta si NO está disparando
if (state == "move") {
    
var _factor_zancada = 0.5; 
image_speed = abs(hsp) / _factor_zancada;
	// --- Colisión Horizontal ---
	if (place_meeting(x + hsp, y, obj_suelo)) {
	    while (!place_meeting(x + sign(hsp), y, obj_suelo)) {
	        x += sign(hsp);
	    }
	    // Si no puede saltar la pared (opcional), podrías hacer que rebote:
	    // hsp = -hsp; 
	}
	x += hsp;
	// Voltear el sprite según la dirección del movimiento
	if (hsp != 0) {
	    image_xscale = sign(hsp) * 0.8; 
	}
	// --- Colisión Vertical ---
	if (place_meeting(x, y + vsp, obj_suelo)) {
	    while (!place_meeting(x, y + sign(vsp), obj_suelo)) {
	        y += sign(vsp);
	    }
	    vsp = 0;
	}
	y += vsp;
    
    // --- Lógica de Detección ---
    var _target = instance_nearest(x, y, obj_player);
    if (_target != noone) {
        // Si el jugador está cerca y el robot tiene permiso de disparar
        if (distance_to_object(_target) < rango_vision && puedo_disparar) {
            state = "attack";
            hsp_guardado = hsp; // Guardamos la velocidad para retomarla luego
            hsp = 0;
            puedo_disparar = false;
            
            // Cambiar al sprite de disparo (Fila 3 de tu imagen)
            sprite_index = spr_spider_attack; 
            image_index = 0;
            
            // Ponemos una alarma para que dispare en medio de la animación
            //alarm[1] = 20; 
        }
    }
}

if (state == "attack") {
    if (floor(image_index) == 5 && !puedo_disparar) { 
        
        var _bullet = instance_create_layer(x + (10 * sign(image_xscale)), y - 4, "Instances", obj_enemy_bullet);
        _bullet.speed = 3 * sign(image_xscale);
        
        // --- AQUÍ LA CORRECCIÓN ---
        // Multiplicamos el tamaño (0.7) por el signo de la dirección para que voltee
        _bullet.image_xscale = 0.7 * sign(image_xscale); 
        _bullet.image_yscale = 0.7;
        
        puedo_disparar = true; 
    }

    if (image_index >= image_number - 1) {
        state = "move";
        hsp = hsp_guardado;
        sprite_index = spr_spider_move;
        
        alarm[3] = 120; 
        puedo_disparar = false; 
    }
}
// Gravedad
vsp += grv;

// --- Lógica de Salto de Obstáculos ---
// Si hay una pared enfrente y está en el suelo, salta
if (place_meeting(x + hsp, y, obj_suelo) && place_meeting(x, y + 1, obj_suelo)) {
    vsp = -5; // Fuerza del salto
}

// --- Muerte ---
if (hp <= 0) {
    // Aquí puedes crear un objeto de explosión o cambiar al sprite de destruido
    instance_create_layer(x, y, "Instances", obj_explosion); 
    instance_destroy();
}

// --- Optimización (Auto-destrucción) ---
// Si el enemigo se sale mucho por la izquierda de la cámara, lo borramos para no gastar memoria
if (x < camera_get_view_x(view_camera[0]) - 100) {
    instance_destroy();
}