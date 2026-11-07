// Velocidades
hsp = 0;        // Velocidad horizontal actual
vsp = 0;        // Velocidad vertical actual
walk_spd = 2.2; // Qué tan rápido corre
jump_spd = -8;  // Fuerza del salto
grav = 0.3;     // Gravedad

damage1=10;

state = "normal"; // Estados: "normal", "hanging"
hang_speed = 2;   // Velocidad al moverse por el tubo
death_timer = 0;   // Para saber cuánto tiempo quedarse acostado
// Control de dirección
look_x = 1;     // 1 = Derecha, -1 = Izquierda
aim_dir = 0;    // Ángulo para la bala (0, 45, 90, etc.)
climb_timer = 0; // Para contar el tiempo de la animación de subida
//disparo
can_shoot = true;    // Indica si el arma está lista para disparar
shoot_delay = 8;    // Cuántos frames esperar entre balas (menor número = más rápido)

_gun_x = 0;
_gun_y = 0;
last_safe_x = x;
last_safe_y = y;

//modo cooperativo:  
player_ID = 1; // Por defecto es el 1. Cuando pongas al segundo en la sala, le cambias esto a 2.

// --- SISTEMA DE SALUD ---
hp = 3;                  // Vidas (corazones)
invincible = false;      // ¿Es inmune ahora mismo?
invincibility_timer = 0; // Tiempo de inmunidad restante
flash_timer = 0;         // Para el efecto visual

coyote_time_max = 6; // Cuántos frames de "aire" le das (6-10 suele estar bien)
coyote_time_counter = 0;
jump_buffer_max = 8;    // Cuántos frames antes del suelo puede presionar salto
jump_buffer_counter = 0; // El temporizador