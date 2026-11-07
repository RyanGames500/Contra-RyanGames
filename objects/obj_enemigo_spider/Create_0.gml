hsp = -3; // Velocidad hacia la izquierda
vsp = 0;
grv = 0.3; // Gravedad
hp = 1;
state = "move";

// Animación inicial
sprite_index = spr_spider_move; // Tu sprite de caminar
image_speed = 1;

image_xscale = 0.8;
image_yscale = 0.8;

puedo_disparar = true;
rango_vision = 150; // Distancia a la que detecta al jugador