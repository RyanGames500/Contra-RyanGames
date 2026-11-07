sprite_index = spr_evil_misile_up; //
image_speed = 1;
hp = 2; // Ocupa 2 balazos para estallar
state = "fly";

// Movimiento orgánico
vspeed = -random_range(2, 4); // Velocidad de subida
oscilacion = random_range(2, 4); // Qué tan amplia es la curva
frecuencia = random_range(0.05, 0.1); // Qué tan rápido hace la curva
tiempo = 0;