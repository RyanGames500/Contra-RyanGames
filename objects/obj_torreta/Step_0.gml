var _dist = distance_to_object(obj_player);

switch (state) {
    case "hidden":
        sprite_index = spr_torreta_active;
        image_index = 0; // Frame del cuadrado/retraída
        image_speed = 0;
        
        if (_dist < dist_deteccion) {
            state = "active";
            image_index = 0;
            image_speed = 1; // Empieza a subir
        }
    break;

    case "active":
        sprite_index = spr_torreta_active;
        // Cuando termina de subir
        if (image_index >= image_number - 1) {
            state = "atack";
            sprite_index = spr_torreta_atack;
            image_index = 0;
            image_speed = 1;
        }
    break;

case "atack":
        sprite_index = spr_torreta_atack;
        
        if (shot_timer > 0) {
            image_index = 0;
            image_speed = 0;
            shot_timer--;
        } else {
            image_speed = 1; 
        }

        if (floor(image_index) == 1 && !bullet_fired) {
            var _bullet = instance_create_layer(x - (15 * image_xscale), y - 23, "Instances", obj_bullet_enemy);
            _bullet.hspeed = -4 * image_xscale;
			_bullet.image_xscale=0.6;
			_bullet.image_yscale=0.6;
            bullet_fired = true;
        }

        if (image_index >= image_number - 1) {
            bullet_fired = false;
            shot_timer = shot_delay;
            
            // --- AQUÍ ESTÁ EL ARREGLO ---
            if (_dist > dist_deteccion) {
                state = "closing";
                sprite_index = spr_torreta_active;
                // Forzamos a que empiece desde el ÚLTIMO frame de la animación de subida
                image_index = image_number - 1; 
                image_speed = -1; 
            }
        }
    break;

    case "closing":
        sprite_index = spr_torreta_active;
        image_speed = -1; 

        // Si el player vuelve a entrar, cancelamos el cierre y subimos
        if (_dist < dist_deteccion) {
            state = "active";
            image_speed = 1;
            // No reseteamos el image_index para que suba desde donde se quedó
        }

        // Si llega al inicio (totalmente guardada)
        // Usamos <= 0.5 para evitar errores de precisión con image_speed negativo
        if (image_index <= 0.5) {
            state = "hidden";
            image_index = 0;
            image_speed = 0;
        }
    break;

    case "die":
        if (sprite_index != spr_torreta_die) {
            sprite_index = spr_torreta_die;
            image_index = 0;
            image_speed = 1;
        }
        if (image_index >= image_number - 1) instance_destroy();
    break;
}

// Daño
if (hp <= 0 && state != "die") state = "die";