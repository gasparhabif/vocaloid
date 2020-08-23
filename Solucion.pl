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
    sonAlMenosDosCanciones(Quien),
    tiempoTotalNovedoso(Canciones).

cantidadCanciones(Cantante, Cantidad) :-
    cantante(Cantante, Canciones),
    length(Canciones, Cantidad).

sonAlMenosDosCanciones(Cantante) :-
    cantidadCanciones(Cantante, CantidadCanciones),
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


cantanteAcelerado(Quien) :-
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
% 1

% concierto(Nombre, Pais, Fama, Tipo)
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 6)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, chico(4)).

% gigante(CancionesMinimas, TiempoMinimo)
% mediano(TiempoTotalMaximo)
% chico(CancionMinima)

% 2
% puedeParticipar(NombreConcierto, Cantante)/2
puedeParticipar(NombreConcierto, hatsuneMiku) :- concierto(NombreConcierto, _, _, _).
puedeParticipar(NombreConcierto, Cantante) :-
    cantante(Cantante, Canciones),
    concierto(NombreConcierto, _, _, TipoConcierto),
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

% 3
cantanteMasFamoso(Famoso) :-
    nivelDeFama(Famoso, FamaMaxima),
    forall((nivelDeFama(OtroCantante, FamaMinima), Famoso \= OtroCantante),
    FamaMinima < FamaMaxima).

nivelDeFama(Cantante, NivelTotal) :-
    findall(Fama, (puedeParticipar(Concierto, Cantante), famaDeConcierto(Concierto, Fama)), FamaDeConciertos),
    sumlist(FamaDeConciertos, Fama),
    cantidadCanciones(Cantante, CantidadCanciones),
    NivelTotal is Fama * CantidadCanciones.

famaDeConcierto(Concierto, Fama) :-
    concierto(Concierto, _, Fama, _).
   
% 4
conoceA(megurineLuka, hatsuneMiku).
conoceA(megurineLuka, gumi).
conoceA(gumi, seeU).
conoceA(seeU, kaito).

seConocen(Catante1, Cantante2) :- conoceA(Catante1, Cantante2).
seConocen(Cantante1, Cantante2) :-
    conoceA(Cantante1, OtroCantante),
    seConocen(OtroCantante, Cantante2).

unicoParticipante(Concierto, Cantante) :-
    puedeParticipar(Concierto, Cantante),
    forall(seConocen(Cantante, Conocido), not(puedeParticipar(Concierto, Conocido))).
    
% 5
% En caso de aparecer un nuevo tipo de concierto simplemente habria que agregar en el punto 2
% las condiciones para que un cantante sea apto para dicho tipo de concierto, ademas de la 
% propia declaracion del concierto entero. El concepto que facilita esta implementacion es el
% de los functores que permiten declarar un concierto en el que incluis un tipo de concierto,
% aunque ese tipo de concierto no sea siempre el mismo.
