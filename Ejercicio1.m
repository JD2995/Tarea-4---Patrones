function Ejercicio1()
    imagen = imread('cuadro1_005.bmp');
    imagen = rgb2gray(imagen);
    tamano = size(imagen);
    hist = histograma(imagen);
    figure();
    plot(hist);
    arrVerosi = zeros(1,256);
    for i=1:256
        arrVerosi(i) = verosimilitud(hist,i);
    end
    figure();
    bar(arrVerosi);
    minimo = min(arrVerosi);
    disp(minimo);
    disp(find(ismember(arrVerosi,minimo)));
end

function histo = histograma(imagen)
    histo = zeros(1,256);
    imagen = imagen(:);
    tamano = size(imagen);
    for i=1:tamano
        histo(imagen(i)+1) = histo(imagen(i)+1)+1;
    end
    histo = histo./tamano(1);
end

function result = verosimilitud(hist,T)
    result = 1+2*(pMarginal(hist,T,1)*log(desvEstandar(hist,T,1))+pMarginal(hist,T,2)*log(desvEstandar(hist,T,2))) -2*(pMarginal(hist,T,1)*log(pMarginal(hist,T,1)) + pMarginal(hist,T,2)*log(pMarginal(hist,T,2)));
end

function result = pMarginal(hist,T,i)
    if(i == 1)
       seccion = hist(1:T);
    else
        seccion = hist(T:256);
    end
    result = sum(seccion);
end

function result = desvEstandar(hist,T,i)
    if(i == 1)
        a = 1;
        b = T;
    else
        a = T;
        b = 256;
    end
    seccion = hist(a:b).*(((a:b)-media(hist,T,i)).^2);
    result = sum(seccion)*(1/pMarginal(hist,T,i));
end

function result = media(hist,T,i)
    if(i == 1)
        a = 1;
        b = T;
    else
        a = T;
        b = 256;
    end
    seccion = hist(a:b).*(a:b);
    result = sum(seccion)*(1/pMarginal(hist,T,i));
end