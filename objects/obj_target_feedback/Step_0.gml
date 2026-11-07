if (instance_exists(target)) {
    // Sigue al jugador
    x = target.x;
    y = target.y-32;
    
    // Efecto visual: parpadeo antes del disparo
    image_alpha = abs(sin(current_time * 0.02));
    image_xscale = 1 + abs(sin(current_time * 0.01));
    image_yscale = image_xscale;
} else {
    instance_destroy();
}