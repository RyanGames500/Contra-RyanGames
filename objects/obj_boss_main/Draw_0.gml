draw_self();

// Si está a punto de cambiar de patrón, brilla un poco
if (timer_fase > 250) {
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_red, 0.3);
    gpu_set_blendmode(bm_normal);
}



//draw_text(x,y+32,fase_ataque)

draw_text(x,y+64,base_core.hp)