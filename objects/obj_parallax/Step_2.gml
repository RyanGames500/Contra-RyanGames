var _cam_x = camera_get_view_x(view_camera[0]);

// CAPAS LEJANAS (Movimiento mínimo)
layer_x("trees5", _cam_x * 0.99); // Cielo
layer_x("trees4", _cam_x * 0.97); // Montañas
layer_x("trees3", _cam_x * 0.94); // Bosque fondo

// CAPAS MEDIAS
layer_x("trees2", _cam_x * 0.90); // Bosque medio

// CAPAS CERCANAS (Aquí está el ajuste)
// "trees1" y "trees" están cerca del jugador, así que deben ser coherentes
layer_x("trees1", _cam_x * 0.85); 

// Si "trees" son los árboles más cercanos (casi tocando al player):
// No bajes de 0.82 o 0.85 para que no "vuelen" frente a tus ojos.
layer_x("trees", _cam_x * 0.82);

// No bajes de 0.82 o 0.85 para que no "vuelen" frente a tus ojos.
layer_x("Rocas", _cam_x * 0.82);