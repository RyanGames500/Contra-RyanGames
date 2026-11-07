// Crear la bala del enemigo
var _bullet = instance_create_layer(x + (10 * sign(image_xscale)), y - 5, "Instances", obj_enemy_bullet);
_bullet.speed = 4 * sign(image_xscale); // Dispara hacia donde mira

// Esperamos un poco antes de volver a caminar
alarm[2] = 30;