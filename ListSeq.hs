module ListSeq where

import Seq

(|||) :: a -> b -> (a, b)
a ||| b = (a, b)

--mapS , appendS, reduceS, scanS {Hacer nosotros}
instance Seq [] where
    emptyS = []
    singletonS x = [x]
    lengthS = length
    nthS l n = l !! n
    tabulateS = tabular
    mapS = mapear
    filterS = filter
    appendS = concatenarLista
    takeS lista n = take n lista
    dropS lista n = drop n lista
    showtS = mostrarArbol
    showlS = mostrarLista
    joinS = concat
    reduceS = reducir
    scanS = escanear
    fromList = id

tabular :: (Int -> a) -> Int -> [a]
tabular f 0 = []
tabular f n = tabular' f n 0

tabular' :: (Int -> a) -> Int -> Int -> [a]
tabular' f 1 i = [f i] 
tabular' f n i = f i : (tabular' f (n-1) (i+1)) 

mapear :: (a -> b) -> [a] -> [b]
mapear f [] = []
mapear f (h: t) = (f h): (mapear f t)
{-
    Consideramos los costos sobre la longitud de la lista
    W (0) = c
    W (n) = k' + W (n-1) + W_f(n) <= W(n-1) + k
    .°. W(n) = O(n)

    Análogo para la profundidad
-}

concatenarLista :: [a] -> [a] -> [a]
concatenarLista [] ys = ys
concatenarLista (h: t) ys = h : (concatenarLista t ys)

{-
    Consideramos los costos sobre la longitud de la primer lista
    W (0) = c
    W (n) = k + W (n-1)
    .°. W(n) = O(n)

    Análogo para la profundidad
-}


mostrarArbol :: [a] -> TreeView a [a]
mostrarArbol []     = EMPTY
mostrarArbol [x]    = ELT x
mostrarArbol xs     = NODE  left  right
                        where
                            mitad = div (length xs) 2
                            (left, right) = splitAt mitad xs

mostrarLista :: [a] -> ListView a [a]
mostrarLista [] = NIL
mostrarLista (h: t) = CONS h t

reducir' :: (a -> a -> a)-> [a] -> a
reducir' oplus [x] = x 
reducir' oplus sequencia = oplus left' right'
    where 
        n = length sequencia
        m = 2 ^ (floor $ (logBase 2 (fromIntegral (n - 1))))
        (left, right) = splitAt m sequencia
        (left', right') = (reducir' oplus left) ||| (reducir' oplus right)

reducir :: (a -> a -> a) -> a -> [a] -> a
reducir oplus neutro [] = neutro
reducir oplus neutro sequencia = oplus neutro (reducir' oplus sequencia)
{-
    **AVERIGUAR COSTOS DE EXPONENTE, LOGARITMO, PISO, CASTEO --- COSTO DE TRANSFORMAR A ARBOL / SI HABIA QUE HACERLO
    ** OPLUS PARA MAPS QUE ONDA WEY
    Consideramos los costos sobre la longitud de la lista
    W (0) = c'
    W (n) = k' + W_oplus + W_reducir'(n) <= k + 2n + W_m + 2W(n/2) <= cn + 2W(n/2)             -- Suponemos suave
    Aplicando el teorema maestro y suavidad

    
    .°. W(n) = O(n * lg n)

    D (0) = 1
    D (n) = 1 + D_oplus + D_reducir'(n) <= k + 2n + D_m + W(n/2) <= cn + W(n/2)             -- Suponemos suave
    Aplicando el teorema maestro y suavidad
    .°. D(n) = O(n)


    Análogo para la profundidad
-}

escanear :: (a -> a -> a) -> a -> [a] -> ([a], a)
escanear oplus n [] = ([],n)
escanear oplus n xs = escanear' oplus xs n

escanear' :: (a -> a -> a) -> [a] -> a -> ([a], a)
escanear' oplus [x] rs = ([], rs `oplus` x)
escanear' oplus (h: t) rs = 
    (e : (fst recursion), (snd recursion))
        where -- ver paralelizar
            e = rs `oplus` h
            recursion = escanear' oplus t e

{-
    Consideramos los costos sobre la longitud de la lista
    W (0) = c
    W (1) = c'
    W (n) = k' + W_escanear'(n) = k + W_escanear'(n-1)
    
    .°. W(n) = O(n)

    Consideramos los costos sobre la longitud de la lista
    D (0) = 1
    D (1) = 2
    D (n) = 1 + max(D_oplus +  D_escanear'(n))
    
    D_escanear'(n) = 1 + D_escanear'(n-1)
    .°. D_escanear'(n) = O(n)

    .°. D(n) = O(n)


    Análogo para la profundidad
-}
