// 1. Seguir a la nave (Esto sigue igual)
if (instance_exists(owner)) {
    x = owner.x + (17 * side);
    y = owner.y - 25;
}
if(owner.base_core.hp < 0) exit;
// --- NUEVA LÓGICA DE MUERTE ---
if (hp <= 0) {
    state = "destruido"; // Cambiamos el estado para que no entre en idle ni apuntando
    image_index = 2;
    image_speed = 0;
    
    // Si muere mientras apuntaba, borramos la mira
    if (instance_exists(mira_instancia)) instance_destroy(mira_instancia);
}

// 2. Control de Estados (SOLO SI TIENE VIDA)
if (hp > 0 && can_attack == true) {
    switch(state) {
        case "idle":
            timer_ataque++;
            if (timer_ataque >= 180) {
                var _target_inst = instance_nearest(x, y, obj_player);
                if (_target_inst != noone) {
                    state = "apuntando";
                    timer_ataque = 0;
                    mira_instancia = instance_create_depth(_target_inst.x, _target_inst.y, -1000, obj_target_feedback);
                    mira_instancia.target = _target_inst;
                }
            }
        break;

        case "apuntando":
            timer_ataque++;
			if (timer_ataque >= 60) { 
			    var _target_inst = instance_nearest(x, y, obj_player);
			    if (_target_inst != noone) {
			        var _proj = instance_create_layer(x, y - 10, "Instances", obj_boss_projectile_big);
        
			        // --- DIFICULTAD DE BALAS ---
			        // Calculamos factor de vida (0 a 1)
			        var _hp_factor = obj_boss_base.hp / 5000;
        
			        // La velocidad vertical base es -6, pero sube hasta -10 si tiene poca vida
			        var _v_speed = -6 - (1 - _hp_factor) * 4; 
			        var _grav = 0.25; 
                    
                    // Tiempo de vuelo REAL (considerando que sube y baja al mismo nivel)
                    var _tiempo_vuelo = abs(_v_speed * 2) / _grav;
                    
                    // IMPORTANTE: Si tu player está más abajo que el cañón, 
                    // necesitamos un poquito más de tiempo de vuelo. 
                    // Le sumamos un pequeño margen para que llegue al suelo.
                    var _extra_caida = 15; // Ajusta este número si cae antes o después
                    var _tiempo_total = _tiempo_vuelo + _extra_caida;

                    var _dest_x = _target_inst.x + (_target_inst.hspeed * _tiempo_total);
                    var _dist_horizontal = _dest_x - x;
                    
                    _proj.hspeed = _dist_horizontal / _tiempo_total;
					_proj.vspeed = _v_speed;
					_proj.gravity = _grav;

                    _proj.image_xscale = 1.2;
                    _proj.image_yscale = 1.2;
                    part_particles_create(global.ps, x, y - 10, global.pt_spark, 10);
                }
                
                if (instance_exists(mira_instancia)) instance_destroy(mira_instancia);
                state = "idle";
                timer_ataque = 0;
            }
        break;
    }


// 3. Visual de daño (Solo si tiene vida recibe el flash rojo)
if (hp > 0) {
    image_blend = (hit == true) ? c_red : c_white;
} else {
    image_blend = c_white; // O c_dkgray para que parezca quemado
}
}