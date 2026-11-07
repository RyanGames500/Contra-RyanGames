// 1. Aparecer el fondo oscuro lentamente
alpha_fondo = lerp(alpha_fondo, 0.6, 0.05);

// 2. Hacer que el texto principal baje rápido
y_texto = lerp(y_texto, display_get_gui_height() / 2 - 50, 0.1);

// 3. Efecto de escribir el sub-texto (aparece después de que el título baja)
if (abs(y_texto - (display_get_gui_height() / 2 - 50)) < 5) {
    if (timer_letras < string_length(sub_texto)) {
        timer_letras += 0.5; // Velocidad de escritura
        letras_actuales = string_copy(sub_texto, 1, floor(timer_letras));
        
        // Sonido de "click" por cada letra
        if (floor(timer_letras) > floor(timer_letras - 0.5)) {
            // audio_play_sound(snd_type_click, 1, false);
        }
    }
}

// 4. Jugar sonido de victoria una sola vez
if (!sonido_jugado) {
    // audio_play_sound(snd_mission_complete, 10, false);
    sonido_jugado = true;

}

// 5. Ir al siguiente nivel tras unos segundos (Enter o espacio)
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
	
    alarm[0]=60; 
}