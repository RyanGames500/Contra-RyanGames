if (puedo_recibir_danio) and owner.hp > 0
{
    hp-=10;
    hit = true;
    with(other) instance_destroy(); // Destruye la bala
} else {
with(other) instance_destroy(); // Destruye la bala
    // Sonido de metal "¡Clang!"
}