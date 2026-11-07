if (act=0){
//act=1

global.inicx=window_get_width();
global.inicy=window_get_height();
aspect_ratio=global.inicx/global.inicy
if aspect_ratio<(1/0.65){aspect_ratio=1/0.65}
if aspect_ratio>(1/0.45){aspect_ratio=1/0.45}

var maxy=147;
//if room=room_continue{maxy=768}else if room=CharSelect2{maxy=225}else if room=CharSelect{maxy=360}else if room=CharSelect_2{maxy=360}else if room=CharSelect_tagMode{maxy=360}
if room=rm_stage1{maxy=300}
camera_set_view_size(view_camera[0],maxy*aspect_ratio,maxy) //190
//surface_resize(application_surface,720*aspect_ratio,720)//comentar cuando este para windows

global.razx=(720*aspect_ratio)/1280;
}



// --- 1. MODO SINGLE PLAYER ---
if (global.game_mode == "single") {
    // Si el jugador ya no existe, significa que perdió todas sus vidas
    if (!instance_exists(obj_player)) {
        global.game_over_desplegado = true;
        
        // Al presionar Enter, el juego se reinicia por completo
        if (keyboard_check_pressed(vk_enter)) {
            game_restart();
        }
    }
}

// --- 2. MODO COOPERATIVO ---
if (global.game_mode == "coop") {
    var _p1_vivo = false;
    var _p2_vivo = false;

    with(obj_player) {
        if (player_ID == 1) _p1_vivo = true;
        if (player_ID == 2) _p2_vivo = true;
    }

    // A. SPAWN INICIAL (Solo una vez al entrar en modo coop)
    if (!global.p2_ya_entro && _p1_vivo) {
        var _cx = camera_get_view_x(view_camera[0]) + 100;
        var _p2 = instance_create_layer(_cx, 0, "Instances", obj_player);
        _p2.player_ID = 2; 
        _p2.hp = 3; // O las vidas iniciales que definas
        global.p2_ya_entro = true;
    }

    // B. LÓGICA DE DERROTA TOTAL
    // Si ambos están muertos, no hay créditos, es Game Over directo
    if (!_p1_vivo && !_p2_vivo) {
        global.game_over_desplegado = true;
        
        if (keyboard_check_pressed(vk_enter)) {
            game_restart();
        }
    }
}


//Kodigo Konami
if (keyboard_check_pressed(vk_anykey)) {
    // Si la tecla presionada es la correcta en la secuencia
    if (keyboard_lastkey == konami_code[konami_index]) {
        konami_index++; // Pasamos a la siguiente tecla
        
        // ¿Completó todo el código?
        if (konami_index >= array_length(konami_code)) {
            
            // --- ¡EFECTO DEL TRUCO! ---
            if (instance_exists(obj_player)) {
                with(obj_player) {
                    hp = 999; // Vida masiva
                    invincible = true;
                    invincibility_timer = 10000; // Casi infinito
                }
            }
            
            audio_play_sound(snd_konami_success, 1, false); // Pon un sonido de éxito
            konami_index = 0; // Reiniciar para poder usarlo de nuevo
        }
    } else {
        // Si se equivoca en una tecla, se reinicia el progreso
        konami_index = 0;
    }
}