//Entrada1 
if (state == "aparicion") {
    // Efecto de "salir del fondo"
    image_alpha += 0.05;
    image_xscale = lerp(image_xscale, 1, 0.1);
    image_yscale = lerp(image_yscale, 1, 0.1);
    
    // Se mueve un poco hacia abajo/adelante
    y += 1;
    
    if (image_alpha >= 1) {
        state = "vuelo"; // Pasa a su comportamiento normal que ya programamos
    }
    exit; // No hace nada más mientras aparece
}

//Entrada2
/*
if (state == "aparicion") {
    // Empieza negro y va recuperando su color
    image_blend = merge_color(c_black, c_white, image_alpha);
    
    image_alpha += 0.03;
    image_xscale = lerp(image_xscale, 1, 0.05);
    image_yscale = lerp(image_yscale, 1, 0.05);
    
    if (image_alpha >= 1) {
        state = "vuelo";
        image_blend = c_white; // Color normal
    }
}
*/
// --- 1. MOVIMIENTO ORGÁNICO ---
if (state != "muerto") {
    if (instance_exists(obj_player)) {
        // Punto de destino (siempre arriba y a un lado del jugador)
        var _dir = (x > obj_player.x) ? 60 : -60;
        var _tx = obj_player.x + _dir;
        var _ty = obj_player.y - 120;

        // Aceleración suave hacia el punto
        if (x < _tx) vx += acel; else vx -= acel;
        if (y < _ty) vy += acel; else vy -= acel;
    }

    // Aplicar fricción para que no se vea rígido
    vx *= fric;
    vy *= fric;

    // Flotación constante (Efecto de motores)
    distancia_flotar += 0.01;
    var _offset_y = dsin(distancia_flotar * 100) * 0.3;

    x += vx;
    y += vy + _offset_y;
}

// --- 2. LÓGICA DE DISPARO POR ANIMACIÓN ---
// Usamos el sprite que tiene la animación completa (vuelo + ataque)
sprite_index = spr_enemy_charge; 
image_speed = 0.8;

// Supongamos que en el frame 14 es donde se ve el destello de la bala
// floor(image_index) detecta el momento exacto del frame
if (floor(image_index) >= 11) {
    // Solo creamos la bala SI NO existe ya una creada en este ciclo
    // para evitar que cree 10 balas en un solo frame
    if (!variable_instance_exists(id, "disparado_este_frame") || !disparado_este_frame) {
        var _inst = instance_create_layer(x, y + 20, "Instances", obj_enemy_bullet_red);
        if (instance_exists(obj_player)) {
            _inst.direction = point_direction(x, y, obj_player.x, obj_player.y-32);
        } else {
            _inst.direction = 270;
        }
        _inst.speed = 2.5;
        disparado_este_frame = true; // Bloqueamos el disparo hasta el siguiente ciclo
    }
} else {
    disparado_este_frame = false; // Reset para la próxima vuelta de animación
}

// --- 3. MUERTE ---
if (hp <= 0 && state != "muerto") 
{
    state = "muerto";
    sprite_index = spr_enemy_die; // Tu sprite de explosión
    image_index = 0;
}

if (state == "muerto") {
    vx *= 0.9; vy *= 0.9; // Se detiene
	sprite_index = spr_enemy_die; // Tu sprite de explosión
    if (image_index >= image_number - 1) instance_destroy();
	
	// --- SOLTAR ITEM AL MORIR ---
	/*
	if (irandom(100) < 30) { // 30% de probabilidad de soltar algo
    var _item = instance_create_layer(x, y, "Instances", obj_item_score);
    _item.vspeed = -4; // Salta un poquito hacia arriba antes de caer
    _item.gravity = 0.2;
}*/
}