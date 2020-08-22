% Parte a - Cantantes

% cantante(Nombre, Canciones)/2
cantante(megurineLuka, [cancion(nightFever, 4), cancion(foreverYoung, 5)]).
cantante(hatsuneMiku, [cancion(tellYourWorld, 4)]).
cantante(gumi, [cancion(foreverYoung, 4), cancion(tellYourWorld, 5)]).
cantante(seeU, [cancion(novemberRain, 6), cancion(nightFever, 5)]).
cantante(kaito, []).

% 1
esNovedoso(Quien) :-
    cantante(Quien, Canciones),
    sonAlMenosDosCanciones(Canciones),
    tiempoTotalNovedoso(Canciones).

sonAlMenosDosCanciones(Canciones) :-
    length(Canciones, CantidadCanciones),
    2 =< CantidadCanciones.

tiempoTotalNovedoso(Canciones) :-
    tiempoTotal(Canciones, Tiempo),
    Tiempo <  15.

tiempoTotal(Canciones, Tiempo) :-
    findall(Duracion, (member(UnaCancion, Canciones), duracionCancion(UnaCancion, Duracion)), Duraciones),
    sumlist(Duraciones, Tiempo).

duracionCancion(cancion(_, Tiempo), Tiempo).
    
% 2
% Se interpterea que kaito al no cantar ninguna cancion
% no es una cantante acelerada. Si se la debiera considerar 
% como una cantante acelerada, el predicado deberia ser el siguiente:

% cantanteAcelrado(Quien) :-
%     cantante(Quien, Canciones),
%     todasCancionesCortas(Canciones).


cantanteAcelrado(Quien) :-
    cantante(Quien, Canciones),
    cantoAlgunaCancion(Canciones),
    todasCancionesCortas(Canciones).

cantoAlgunaCancion(Canciones) :-
    length(Canciones, Cantidad),
    0 < Cantidad.

todasCancionesCortas([]).
todasCancionesCortas([Cancion | Canciones]) :-
    duracionCancion(Cancion, Duracion),
    Duracion =< 4,
    todasCancionesCortas(Canciones).

% Parte b - Conciertos

% concierto(Nombre, Pais, Fama, Tipo)

% gigante(CancionesMinimas, TiempoMinimo)
% mediano(TiempoTotalMaximo)
% chico(CancionMinima)

concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 6)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, chico(4)).

% 1
% puedeParticipar(NombreConcierto, Cantante)/2
puedeParticipar(NombreConcierto, hatsuneMiku) :- concierto(NombreConcierto, _, _, _).
puedeParticipar(NombreConcierto, Cantante) :-
    concierto(NombreConcierto, _, _, TipoConcierto),
    cantante(Cantante, Canciones),
    esAptoParaConcierto(TipoConcierto, Canciones).

esAptoParaConcierto(gigante(CancionesMinimas, TiempoMinimo), Canciones) :-
    length(Canciones, CantidadCanciones),
    tiempoTotal(Canciones, TiempoTotal),
    CancionesMinimas =< CantidadCanciones,
    TiempoMinimo =< TiempoTotal.
esAptoParaConcierto(mediano(TiempoMaximo), Canciones) :-
    tiempoTotal(Canciones, TiempoTotal),
    TiempoTotal < TiempoMaximo.
esAptoParaConcierto(chico(DuracionMinima), Canciones) :-
    member(Cancion, Canciones),
    duracionCancion(Cancion, Duracion),
    DuracionMinima =< Duracion.
