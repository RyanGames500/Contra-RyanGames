if (!instance_exists(owner)) exit; // Si no hay jefe, no hace nada

// Seguir al jefe siempre
x = owner.x + (38.3 * side);
y = owner.y - 10;

if (can_attack == true) 
{
timer++;

switch(state) {
	case "idle":
	    // Aumentamos el tiempo de espera a 300 frames (5 segundos aprox)
	    // Pero como el JEFE les da valores diferentes al timer, saldrán a destiempo
	    if (timer >= 300) { 
	        state = "firing";
	        timer = 0;
	    }
	break;

	case "firing":
	    // Solo dispara si hay MENOS de 1 misil en pantalla (puedes subirlo a 2 si quieres)
	    if (instance_number(obj_boss_missile) < 1) { 
			// Dentro del case "firing":
			var _missile = instance_create_layer(x, y, "Instances", obj_boss_missile);
			_missile.direction = (side == 1) ? 0 : 180;

			// --- VELOCIDAD DE MISIL ESCALABLE ---
			var _hp_factor = obj_boss_base.hp / 5000;
			// El misil empieza en velocidad 2 y sube hasta 5
			_missile.speed = 2 + (1 - _hp_factor) * 3; 

			// También aumentamos su capacidad de giro para que sea una pesadilla
			_missile.turn_speed = 1.5 + (1 - _hp_factor) * 3.5;
	        //_missile.side = side; 
        
	        state = "reloading";
	        timer = 0;
	    } else {
	        // Si ya hay un misil, reiniciamos un poco el timer para que vuelva a intentar pronto
	        timer = 280; 
	    }

	break;

    case "reloading":
        if (timer >= 90) { // 1.5 segundos de recarga
            state = "idle";
            timer = 0;
        }
    break;
}

}
else 
{
    // Si no puede atacar, reseteamos todo para que esté listo
    timer_ataque = 0;
    state = "idle";
    //if (instance_exists(mira_instancia)) instance_destroy(mira_instancia);
    
    // Feedback visual opcional: Se ve oscuro si está apagado
    image_blend = c_dkgray; 
}