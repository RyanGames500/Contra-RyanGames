// A quién sigue la cámara
following = obj_player;

// Dimensiones de la vista (ajústalo a tu resolución, ej: 480x270 o 640x360)
cam_width = 480; 
cam_height = 270;

// Variables para el suavizado
x_to = x;
y_to = y;

// Offset (Para que la cámara mire más hacia adelante)
target_offset_x = 0;

max_x = x; // Guardará la posición máxima alcanzada por la cámara

//temblor efecto sexy
shake_remain = 0;
shake_magnitude = 0;