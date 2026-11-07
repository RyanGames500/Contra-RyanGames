// Inicializamos las variables globales para el sistema
global.ps = part_system_create();
part_system_depth(global.ps, -10000);

// --- PARTÍCULA DE CHISPA ---
global.pt_spark = part_type_create();
part_type_shape(global.pt_spark, pt_shape_flare);
part_type_size(global.pt_spark, 0.05, 0.2, -0.01, 0);
part_type_color2(global.pt_spark, c_white, c_orange);
part_type_speed(global.pt_spark, 2, 4, -0.1, 0);
part_type_direction(global.pt_spark, 0, 360, 0, 0);
part_type_life(global.pt_spark, 10, 20);
part_type_blend(global.pt_spark, true); // Esto le da el brillo "Glow"

// --- SANGRE PIXELADA Y PEQUEÑA ---
global.pt_blood = part_type_create();

part_type_shape(global.pt_blood, pt_shape_disk); 

// TAMAÑO: Súper chiquitos (entre 0.02 y 0.06) para que parezcan gotas reales
part_type_size(global.pt_blood, 0.02, 0.06, -0.001, 0); 

// COLOR: Un rojo intenso que se oscurece
part_type_color2(global.pt_blood, c_red, make_color_rgb(80, 0, 0));

// MOVIMIENTO: Salen rápido pero frenan por el aire
part_type_speed(global.pt_blood, 2, 5, -0.15, 0); 
part_type_direction(global.pt_blood, 0, 360, 0, 10);

// GRAVEDAD: Pesada para que caiga rápido al suelo
part_type_gravity(global.pt_blood, 0.35, 270);

// VIDA: Fugaz, para que se vea el impacto y desaparezca
part_type_life(global.pt_blood, 10, 20);

part_type_blend(global.pt_blood, false);

// --- PARTÍCULA DE HUMO (Para explosiones o cañones) ---
global.pt_smoke = part_type_create();
part_type_sprite(global.pt_smoke, spr_smoke_particle, true, false, false); // O usa pt_shape_cloud si no tienes sprite
part_type_size(global.pt_smoke, 0.2, 0.5, 0.01, 0);
part_type_color2(global.pt_smoke, c_gray, c_dkgray);
part_type_alpha3(global.pt_smoke, 0, 0.5, 0); // Aparece suave, se ve, y desaparece
part_type_speed(global.pt_smoke, 0.5, 1.5, -0.02, 0);
part_type_direction(global.pt_smoke, 0, 360, 0, 10);
part_type_life(global.pt_smoke, 40, 60);

// --- PARTÍCULA DE FRAGMENTOS (Trozos de metal/suelo) ---
global.pt_debris = part_type_create();
part_type_shape(global.pt_debris, pt_shape_square);
part_type_size(global.pt_debris, 0.02, 0.05, 0, 0);
part_type_color1(global.pt_debris, c_orange);
part_type_speed(global.pt_debris, 2, 5, -0.1, 0);
part_type_direction(global.pt_debris, 45, 135, 0, 0); // Salen hacia arriba
part_type_gravity(global.pt_debris, 0.25, 270); // Caen por gravedad
part_type_life(global.pt_debris, 30, 50);

// --- PARTÍCULA DE CASQUILLOS (Shells) ---
global.pt_shell = part_type_create();
// Si tienes un sprite de un pixel o un rectangulito úsalo, 
// si no, pt_shape_line o pt_shape_square escalado sirven:
part_type_shape(global.pt_shell, pt_shape_line); 
part_type_size(global.pt_shell, 0.05, 0.1, 0, 0);
// TRUCO: Escalamos el eje X para que sea alargado como una bala
part_type_scale(global.pt_shell, 1, 0.3); 
// Cambia el color por uno más metálico (Dorado a Naranja quemado)
part_type_color2(global.pt_shell, make_color_rgb(255, 215, 0), make_color_rgb(184, 134, 11)); 
part_type_alpha2(global.pt_shell, 1, 0.8); // Que no se desvanezcan tanto al caer
// ROTACIÓN: Esto hace que den vueltas en el aire al caer
part_type_orientation(global.pt_shell, 0, 360, 15, 0, false); // Mucho giro
part_type_speed(global.pt_shell, 2, 4, -0.1, 0);
// DIRECCIÓN: Salen hacia arriba y un poco hacia atrás del jugador
// Si miras a la derecha (look_x = 1), deben salir hacia 135° aprox.
part_type_direction(global.pt_shell, 110, 160, 0, 0); 
part_type_gravity(global.pt_shell, 0.3, 270); // Caída rápida
part_type_life(global.pt_shell, 40, 60);