with (other) {
    // Solo si no es invencible (para evitar que rebote mil veces seguidas)
    if (!invincible) {
        // --- TU LÓGICA DE DAÑO EXACTA ---
        part_particles_create(global.ps, x, y-32, global.pt_blood, 15);
        hp -= 1;
        invincible = true;
        invincibility_timer = 120; 
        state = "hit";
        death_timer = 0;
        
        // --- EL RESCATE ---
        // En lugar de un impulso cualquiera, lo teletransportamos 
        // al último suelo seguro y le damos el impulso ahí
        x = last_safe_x;
        y = last_safe_y - 10; // Un poquito arriba para que no se trabe
        
        vsp = -6; // El brinco que querías
        hsp = (look_x == 1) ? -2 : 2; // Empujón hacia atrás
        
        if (global.sfx == true) { 
            audio_play_sound(snd_Player_death, 1, 0); 
        }
    }
}