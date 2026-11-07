
fase_ataque = 1;
timer_fase = 0;
image_speed = 0;
image_index = 0;
t2 = 0

aviso_canones = false;
aviso_misiles = false;
timer_aviso = 0; // Para efectos de parpadeo

// Para la entrada
state = "entrada"; 
y = -900; // Empieza arriba de la pantalla, fuera de vista
y_objetivo = 80; // La altura donde se detendrá para pelear

// Para la caída
v_speed_caida = 0;
// Coordenadas de anclaje (Offsets) para que cada parte sepa donde ir
// Estos números los puedes ajustar moviendo los objetos en el editor
arm_L = instance_create_layer(x - 70, y + 50, "Instances", obj_boss_arm);
arm_L.side = -1;
arm_L.owner = id;

var _beam_L = instance_create_layer(x, y, "Instances", obj_boss_beam_connector);
_beam_L.owner_boss = id;
_beam_L.owner_arm = arm_L;

arm_R = instance_create_layer(x + 70, y + 50, "Instances", obj_boss_arm);
arm_R.side = 1;
arm_R.owner = id;

var _beam_R = instance_create_layer(x, y, "Instances", obj_boss_beam_connector);
_beam_R.owner_boss = id;
_beam_R.owner_arm = arm_R;

//Los cañones de arriba (cannon1 y cannon2)
top_gun1 = instance_create_layer(x - 30, y - 40, "Instances", obj_boss_cannon);
top_gun1.owner = id;
top_gun1.side = 1;
top_gun1.timer_ataque = 120; // Solo le faltan 60 frames

top_gun2 = instance_create_layer(x - 30, y - 40, "Instances", obj_boss_cannon);
top_gun2.owner = id;
top_gun2.side = -1;
top_gun2.timer_ataque = 0; // Solo le faltan 60 frames

top_gun3 = instance_create_layer(x + 60, y - 40, "Instances", obj_boss_cannon);
top_gun3.owner = id;
top_gun3.side = 0;
top_gun3.timer_ataque = 60; // Solo le faltan 60 frames

// Creamos los lanzadores y les pasamos nuestra ID directamente
launcher_L = instance_create_layer(x - 92, y - 5, "Instances", obj_boss_launcher);
launcher_L.owner = id;
launcher_L.side = -1;

launcher_R = instance_create_layer(x + 92, y - 5, "Instances", obj_boss_launcher);
launcher_R.owner = id;
launcher_R.side = 1;

base_core = instance_create_layer(x, y + 35, "Instances", obj_boss_base);
base_core.owner = id; // Le pasamos el ID del jefe para que sepa a quién seguir

hp = base_core.hp;