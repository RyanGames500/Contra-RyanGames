var _layer_id = layer_get_id("trees"); // Cambia esto al nombre de tu capa
if (layer_exists(_layer_id)) {
    layer_set_visible(_layer_id, false); // Apagarlo antes de salir evita el error matemático
}

// 1. CHISPAS
if (variable_global_exists("pt_spark")) {
    if (part_type_exists(global.pt_spark)) part_type_destroy(global.pt_spark);
}

// 2. SANGRE
if (variable_global_exists("pt_blood")) {
    if (part_type_exists(global.pt_blood)) part_type_destroy(global.pt_blood);
}

// 3. HUMO
if (variable_global_exists("pt_smoke")) {
    if (part_type_exists(global.pt_smoke)) part_type_destroy(global.pt_smoke);
}

// 4. CASQUILLOS
if (variable_global_exists("pt_shell")) {
    if (part_type_exists(global.pt_shell)) part_type_destroy(global.pt_shell);
}

// 5. POR ÚLTIMO EL SISTEMA
if (variable_global_exists("ps")) {
    if (part_system_exists(global.ps)) part_system_destroy(global.ps);
}

show_debug_message("¡Memoria de partículas limpia, bro!");