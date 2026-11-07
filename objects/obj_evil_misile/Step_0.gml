if (state == "fly") {
    tiempo += 1;
    // Esto hace que se mueva de izquierda a derecha mientras sube
    x += sin(tiempo * frecuencia) * oscilacion;

	// Colisión con el player
    var _player = instance_place(x, y, obj_player);
    
    if (_player != noone) {
        // Si el player no es invencible, activamos tu lógica de daño
        with (_player) {
            if (!invincible) {
                // Partículas y daño
                part_particles_create(global.ps, x, y-32, global.pt_blood, 15);
                hp -= 1;
                invincible = true;
                invincibility_timer = 120; 
                state = "hit";
                death_timer = 0;
                
                // Impulso (Knockback)
                vsp = -6; 
                // El impulso es hacia el lado opuesto del misil
                hsp = (x < other.x) ? -2 : 2; 
                y -= 2; 
                
                if(global.sfx == true) { audio_play_sound(snd_Player_death, 1, 0); }
            }
        }
        
        // El misil siempre explota al tocar al player
        state = "explode";
    }
}

if (state == "explode") {
    if (sprite_index != spr_evil_misile_destroy) { //
        sprite_index = spr_evil_misile_destroy;
        image_index = 0;
        vspeed = 0;
        hspeed = 0;
    }
    if (image_index >= image_number - 1) instance_destroy();
}

// Sistema de vida
if (hp <= 0 && state != "explode") state = "explode";