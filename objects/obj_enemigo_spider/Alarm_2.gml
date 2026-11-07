state = "move";
hsp = hsp_guardado; // Recupera su velocidad original
sprite_index = spr_spider_move;

// Tiempo de espera para que no dispare como ametralladora (Cooldown)
alarm[3] = 120;