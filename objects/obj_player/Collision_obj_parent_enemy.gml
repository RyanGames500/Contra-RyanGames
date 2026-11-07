if (!invincible) {
	part_particles_create(global.ps, x, y-32, global.pt_blood, 15);
    hp -= 1;
    invincible = true;
    invincibility_timer = 120; 
    state = "hit";
    death_timer = 0;
    
    // El impulso
    vsp = -6; 
    hsp = (x < other.x) ? -2 : 2; 
    
    // DESPEGUE: Lo subimos 2 píxeles para que no detecte el suelo 
    // en este frame y el knockback pueda arrancar
    y -= 2; 
	
	//Sonido de muerte
	if(global.sfx==true){audio_play_sound(snd_Player_death,1,0);}
}