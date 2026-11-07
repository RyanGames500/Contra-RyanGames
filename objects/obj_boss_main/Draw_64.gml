// --- DIBUJAR ADVERTENCIA ARCADE ---
if ((aviso_canones || aviso_misiles) && timer_aviso < 120) {
    timer_aviso++;
    
    if ((timer_aviso div 10) % 2 == 0) {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(-1); 

        // Cambiamos el texto dependiendo de cuál aviso se activó último
        var _txt = "¡WARNING!\nARTILLERÍA ACTIVA"; // Texto por defecto (Fase 1)
        
        if (aviso_misiles && timer_aviso < 120) {
            _txt = "¡DANGER!\nMISILES RASTREADORES"; // Texto para la Fase 2
        }

        // Sombra
        draw_text_transformed_color(_gui_w/2 + 3, _gui_h/4 + 3, _txt, 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 0.5);
        
        // Color: Amarillo para cañones, Naranja/Rojo puro para misiles
        var _col1 = (aviso_misiles) ? c_orange : c_yellow;
        var _col2 = c_red;
        
        draw_text_transformed_color(_gui_w/2, _gui_h/4, _txt, 1.5, 1.5, 0, _col1, _col1, _col2, _col2, 1);
    }
}