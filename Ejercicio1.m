function Ejercicio1()
    Kittler('cuadro1_005.bmp');
    Kittler('trackedCell15.tif');
end

function Kittler(pathImagen)
    imagen = imread(pathImagen);
    imagen = rgb2gray(imagen);
    tamano = size(imagen);
    hist = histograma(imagen);
    figure;
    plot(hist);
    arrVerosi = zeros(1,255);
    for i=1:255
        arrVerosi(i) = verosimilitud(hist,i);
    end
    figure;
    bar(arrVerosi);
    minimo = min(arrVerosi);
    %disp(minimo);
    minimos = find(ismember(arrVerosi,minimo));
    result = minimos(1);
    p1 = pMarginal(hist,result,1);
    p2 = pMarginal(hist,result,2);
    desv1 = varianzaNormalizada(hist,result,1);
    desv2 = varianzaNormalizada(hist,result,2);
    med1 = mediaNormalizada(hist,result,1);
    med2 = mediaNormalizada(hist,result,2);
    umbralizada = umbralizacion(imagen,result);
    figure;
    imshow(umbralizada);
    disp(med1);
    disp(med2);
    disp(desv1);
    disp(desv2);
end

function result = umbralizacion(imagen,T)
    result = imagen > T;
end

function histo = histograma(imagen)
    histo = zeros(1,256);
    imagen = imagen(:);
    tamano = size(imagen);
    for i=1:tamano(1)
        histo(imagen(i)+1) = histo(imagen(i)+1)+1;
    end
    histo = histo./tamano(1);
end

function result = verosimilitud(hist,T)
    p1 = pMarginal(hist,T,1);
    p2 = pMarginal(hist,T,2);
    desv1 = sqrt(varianza(hist,T,1));
    desv2 = sqrt(varianza(hist,T,2));
    result = 1+2*(p1*log(desv1)+p2*log(desv2)) -2*(p1*log(p1)+p2*log(p2));
end

function result = pMarginal(hist,T,i)
    if(i == 1)
       seccion = hist(1:T+1);
    else
        seccion = hist(T:256);
    end
    result = sum(seccion);
end

function result = varianza(hist,T,i)
    if(i == 1)
        a = 1;
        b = T+1;
    else
        a = T;
        b = 256;
    end
    seccion = hist(a:b).*(((a-1:b-1)-media(hist,T,i)).^2);
    result = sum(seccion);
end

function result = varianzaNormalizada(hist,T,i)
    if(i == 1)
        a = 1;
        b = T+1;
    else
        a = T;
        b = 256;
    end
    seccion = hist(a:b).*(((a-1:b-1)-media(hist,T,i)/pMarginal(hist,T,i)).^2);
    result = sum(seccion)/pMarginal(hist,T,i);
end

function result = media(hist,T,i)
    if(i == 1)
        a = 1;
        b = T+1;
    else
        a = T;
        b = 256;
    end
    seccion = hist(a:b).*(a-1:b-1);
    result = sum(seccion);
end

function result = mediaNormalizada(hist,T,i)
    if(i == 1)
        a = 1;
        b = T+1;
    else
        a = T;
        b = 256;
    end
    seccion = hist(a:b).*(a-1:b-1);
    result = sum(seccion)/pMarginal(hist,T,i);
end