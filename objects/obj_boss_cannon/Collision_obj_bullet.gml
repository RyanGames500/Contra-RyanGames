if (hp > 0) and can_attack = true
{
    hp-=10; // O el daño que haga tu bala
    hit = true;
    alarm[0] = 5; // Para quitar el hit rojo
}
// Si hp ya es 0, el código no hace nada, ignorando la bala.