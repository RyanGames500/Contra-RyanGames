
// 1. LEER EL TECLADO SEGÚN EL ID DEL JUGADOR
var _key_left, _key_right, _key_up, _key_down, _key_jump, _key_shoot;

if (player_ID == 1) {
    _key_left  = keyboard_check(vk_left);
    _key_right = keyboard_check(vk_right);
    _key_up    = keyboard_check(vk_up);
    _key_down  = keyboard_check(vk_down);
    _key_jump  = keyboard_check_pressed(ord("A")); 
    _key_shoot = keyboard_check(ord("Z"));         
} else {
    _key_left  = keyboard_check(ord("A"));
    _key_right = keyboard_check(ord("D"));
    _key_up    = keyboard_check(ord("W"));
    _key_down  = keyboard_check(ord("S"));
    _key_jump  = keyboard_check_pressed(ord("K")); 
    _key_shoot = keyboard_check(ord("J"));         
}

// Si presionas el botón, reseteamos el buffer al máximo
if (_key_jump) jump_buffer_counter = jump_buffer_max;

// El buffer siempre va bajando cada frame
if (jump_buffer_counter > 0) jump_buffer_counter -= 1;
// 2. DETECCIÓN DE ENTORNO
var _rail  = instance_place(x, y - 5, obj_rail);       
var _climb = instance_place(x, y, obj_wall_climb);   
var _on_ground = place_meeting(x, y + 1, obj_suelo);

if (_on_ground) {
    coyote_time_counter = coyote_time_max; // Recargamos el tiempo mientras pisa suelo
} else {
    coyote_time_counter -= 1; // Empezamos a perder el tiempo de gracia en el aire
}

if (!variable_instance_exists(id, "climb_cooldown")) climb_cooldown = 0;
if (climb_cooldown > 0) climb_cooldown -= 1;

// --- GRAVEDAD UNIVERSAL ---
if (state != "climbing" && state != "hanging" && state != "climb_finish") {
    if (!_on_ground) vsp += grav;
}

// 3. MÁQUINA DE ESTADOS
switch (state) {
    case "climbing":
        hsp = 0; 
        vsp = (_key_down - _key_up) * hang_speed;
        if (_key_down && _on_ground) { state = "normal"; vsp = 0; y -= 1; }
        if (!place_meeting(x, y - 15, obj_wall_climb) && _key_up) {
            state = "climb_finish"; climb_timer = 0; vsp = 0;
        }
        if (_key_jump) { state = "normal"; vsp = 0; climb_cooldown = 15; }
        if (_climb == noone) state = "normal";
        break;

    case "climb_finish":
        vsp = 0; hsp = look_x * 2; sprite_index = spr_player_climb_end; 
        climb_timer += 1;
        if (climb_timer < 8) y -= 2; 
        if (climb_timer >= 12) { state = "normal"; hsp = 0; y -= 10; x += 15 * look_x; }
        break;

    case "hanging":
        vsp = 0;
        var _h_move = _key_right - _key_left;
        if (_key_shoot) hsp = 0; else hsp = _h_move * hang_speed;
        if (_h_move != 0) look_x = _h_move; 
        if (_key_jump) {
            state = "normal";
            vsp = _key_down ? 2 : jump_spd;
            climb_cooldown = 20;
			coyote_time_counter = 0;
        }
        if (_rail == noone) state = "normal";
		
		last_safe_x = x;
        last_safe_y = y; 
        if (_rail == noone) state = "normal";
        break;

case "hit":
        // 1. CHEQUEO DE RESCATE (Esto va antes de todo)
        if (y > room_height + 100) {
            if (hp > 0) {
                x = last_safe_x;
                y = last_safe_y;
                vsp = 0;
                hsp = 0;
                image_angle = 0;
                death_timer = 0; // Reseteamos el timer para que no aparezca acostado en el aire
                state = "normal"; 
                invincible = true;
                invincibility_timer = 90; // Le damos tiempo extra para reaccionar
                exit; // Salimos del evento este frame para evitar errores
            } else {
                instance_destroy();
                exit;
            }
        }

        // 2. TU LÓGICA DE SIEMPRE (Knockback y caída)
        if (!_on_ground && death_timer == 0) {
            sprite_index = spr_player_knockback; 
            image_angle += (hsp > 0) ? -15 : 15; 
            hsp = lerp(hsp, 0, 0.02); 
        } else {
            image_angle = 0; 
            sprite_index = spr_player_acostado; 
            hsp = 0; vsp = 0; 
            if (!place_meeting(x, y + 1, obj_suelo)) y += 1; 
            death_timer++;
            
            if (death_timer > 40) && (hp > 0) {
                state = "normal";
                death_timer = 0;
            }
            else if (death_timer > 40) && (hp <= 0) {
                if (place_meeting(x, y + 1, obj_suelo)) {
                    instance_destroy();
                    death_timer = 0;
                }
            }
        }
        break;

    case "normal":
        var _move = _key_right - _key_left;
        hsp = _move * walk_spd;
        if (_move != 0) look_x = _move;
		if (jump_buffer_counter > 0) { // ¿El jugador intentó saltar hace poco?
    
		    // CASO A: Está en el suelo o en tiempo de Coyote
		    if (coyote_time_counter > 0) {
		        vsp = jump_spd;
		        coyote_time_counter = 0; 
		        jump_buffer_counter = 0; // Limpiamos el buffer para no saltar de nuevo
		    }
		}

        if (climb_cooldown <= 0) {
            if (_climb != noone) {
                if (!_on_ground || (_on_ground && _key_up)) {
                    state = "climbing";
                    x = _climb.x; hsp = 0; vsp = 0;
                }
            }
            else if (_rail != noone && !_on_ground) {
                state = "hanging";
                y = _rail.y + 50; vsp = 0;
            }
        }
		
		if (_on_ground) {
            last_safe_x = x;
            last_safe_y = y;
        }
        break;
}

// 4. COLISIONES FÍSICAS
if (state != "climbing" && state != "climb_finish") {
    if (place_meeting(x + hsp, y, obj_suelo)) {
        while (!place_meeting(x + sign(hsp), y, obj_suelo)) x += sign(hsp);
        hsp = 0;
    }
    x += hsp;
    if (place_meeting(x, y + vsp, obj_suelo)) {
        while (!place_meeting(x, y + sign(vsp), obj_suelo)) y += sign(vsp);
        vsp = 0;
    }
    y += vsp;
} else {
    x += hsp; y += vsp;
}

// 5. ANIMACIONES
image_xscale = look_x;
if (state == "hit") {
    // Manejado en la máquina de estados
} else {
    image_angle = 0;
    if (state == "climbing") {
        if (vsp != 0) sprite_index = spr_player_climb_move; else sprite_index = spr_player_climb_idle;
    } 
    else if (state == "hanging") {
        if (_key_shoot) {
            if (_key_up) {
                if (_key_right || _key_left) sprite_index = spr_player_hang_up_diag; else sprite_index = spr_player_hang_up;
            } else if (_key_down) {
                if (_key_right || _key_left) sprite_index = spr_player_hang_down_diag; else sprite_index = spr_player_hang_down;
            } else sprite_index = spr_player_hang_idle;
        } else {
            if (hsp != 0) sprite_index = spr_player_hang_move; else sprite_index = spr_player_hang_idle;
        }
    } 
    else if (state == "normal") {
        if (_on_ground) {
            if (hsp != 0) {
                if (_key_up) sprite_index = spr_player_run_up;
                else if (_key_down) sprite_index = spr_player_run_down_diag;
                else sprite_index = spr_player_run;
            } else {
                if (_key_up) sprite_index = spr_player_idle_up;
                else if (_key_down) sprite_index = spr_player_crouch;
                else sprite_index = spr_player_idle;
            }
        } else {
            sprite_index = spr_player_jump; 
        }
    }
}

/// 6. SISTEMA DE DISPARO
if (_key_shoot && can_shoot && state != "climbing" && state != "climb_finish" && state != "hit") {
    var _dir = 0;
    var _input_h = _key_right - _key_left; 

    if (_key_up) {
        if (_input_h != 0) _dir = (look_x == 1) ? 45 : 135;
        else _dir = 90;
    } 
    else if (_key_down) {
        if (_input_h != 0) _dir = (look_x == 1) ? 315 : 225;
        else {
            if (_on_ground) _dir = (look_x == 1) ? 0 : 180;
            else _dir = 270;
        }
    } 
    else {
        _dir = (look_x == 1) ? 0 : 180;
    }

    var _ox = 0; var _oy = 0; var _dist = 38; 
    switch (sprite_index) {
        case spr_player_hang_idle:
        case spr_player_hang_move:      _oy = -37; _ox = -10; break;
        case spr_player_hang_up:        _oy = -20; _ox = -3;  break;
        case spr_player_hang_down:      _oy = -45; _ox = 5;   break;
        case spr_player_hang_up_diag:   _oy = -28; _ox = -6;  break;
        case spr_player_hang_down_diag: _oy = -45; _ox = -3;  break;
        case spr_player_idle:           _oy = -38; _ox = -10; break;
        case spr_player_run:            _oy = -35; _ox = -10; break;
        case spr_player_run_up:         _oy = -25; _ox = -5;  break;
        case spr_player_run_down_diag:  _oy = -45; _ox = -1;  break;
        case spr_player_jump:           _oy = -30; _ox = 0; _dist = 25; break;
        case spr_player_crouch:         _oy = -27; _ox = 5; _dist = 25; break;
        case spr_player_idle_up:        _oy = -38; _ox = -1; _dist = 25; break;
        default:                        _oy = -38; _ox = 0; break;
    }

    _gun_x = x + (lengthdir_x(_dist, _dir)) + (_ox * look_x);
    _gun_y = y + _oy + (lengthdir_y(_dist, _dir));

    var _bullet = instance_create_layer(_gun_x, _gun_y, "Instances", obj_bullet);
    _bullet.direction = _dir;
    _bullet.image_angle = _dir;
    _bullet.speed = 12;
	_bullet.image_xscale = 0.6;
	_bullet.image_yscale = 0.6;

    var _flash = instance_create_layer(_gun_x, _gun_y, "Instances", obj_muzzle_flash);
    _flash.image_angle = _dir;

	// 1. Calculamos la posición: un poco arriba y atrás del cañón
	var _shell_x = _gun_x - (8 * look_x); 
	var _shell_y = _gun_y - 5; 

	// 2. Calculamos la dirección de salida: 
	// Queremos que salgan hacia ARRIBA y hacia ATRÁS del jugador
	var _dir_salida;
	if (look_x == 1) _dir_salida = random_range(110, 150); // Si mira a la derecha, salen hacia atrás-izq
	else _dir_salida = random_range(30, 70);             // Si mira a la izquierda, salen hacia atrás-der

	// 3. Aplicamos la dirección solo a esa partícula antes de crearla
	part_type_direction(global.pt_shell, _dir_salida, _dir_salida, 0, 0);

	// 4. Creamos el casquillo
	part_particles_create(global.ps, _shell_x, _shell_y, global.pt_shell, 1);
	
    can_shoot = false;
    alarm[0] = shoot_delay;
}


// 7. BLOQUEO CÁMARA
if (instance_exists(obj_camera)) {
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_w = camera_get_view_width(view_camera[0]);
    x = clamp(x, _cam_x + 16, _cam_x + _cam_w - 16);
}

// 8. INVENCIBILIDAD
if (player_ID == 2) image_blend = c_aqua;
if (invincible) {
    invincibility_timer -= 1;
    flash_timer += 1;
    if (flash_timer % 4 == 0) image_alpha = 0; else image_alpha = 1;
    if (invincibility_timer <= 0) { invincible = false; image_alpha = 1; }
}


