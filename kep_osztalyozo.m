clc;
clear all;
close all;
%C:\Users\Me\Downloads\101_ObjectCategories\airplanes --kepek eleresi
%utvonala
digitDatasetPath1 = fullfile('C:','Users','Me','Downloads','101_ObjectCategories','joshua_tree');
digitDatasetPath2 = fullfile('C:','Users','Me','Downloads','101_ObjectCategories','garfield');

%kepek betoltese
imds1 = imageDatastore(digitDatasetPath1,'IncludeSubfolders',true,'LabelSource','foldernames');
imds2 = imageDatastore(digitDatasetPath2,'IncludeSubfolders',true,'LabelSource','foldernames');

imds1_size=size(imds1.Files);
imds2_size=size(imds2.Files);

%1. osztaly kepeinek beolvasasa es atmeretezese
numrows=250;
numcols=300; %kb. ezek az ertekek jelentik az atlagmeretet

for i=1 : imds1_size(1)
    class1{i} = imresize(readimage(imds1,i),[numrows,numcols]);
end

%2. osztaly kepeinek beolvasasa es atmeretezese
for i=1 : imds2_size(1)
    class2{i} = imresize(readimage(imds2,i),[numrows numcols]);
end

%szines kepek atalakitasa szurkere (nem latom ertelmet 3 matrix-al (rgb) tanitattni a neuronhalot)
for i=1:imds1_size(1)
        if size(class1{i},3)==3
            class1_bit{i}= {rgb2gray(class1{i})>128};
        else
            class1_bit{i}= class1{i}>128;
        end
end

for i=1:imds2_size(1)
        if size(class2{i},3)==3
            class2_bit{i}= {rgb2gray(class2{i})>128};
        else
            class2_bit{i}= class2{i}>128;
        end
end


%nehany kep megmutatasa egyik ill. masik osztalybol
figure(1);
title('class1')
perm = randperm(10000,20);
for i = 1:4
    subplot(2,2,i);
    imshow(class1{i});   
end

figure(2);
title('class2')
perm = randperm(10000,20);
for i = 1:4
    subplot(2,2,i);
    imshow(class2{i}); 
end

%neuronhalo

%tanito halmaz

%osztalyok kette osztasa egyik resz tanitohalmaznak masik resz
%teszthalmaznak
half1=size(class1_bit)/2;
end1=size(class1_bit);

class1_bit_firsthalf=class1_bit{1};
for i=2:half1(2)
class1_bit_firsthalf=cat(1,class1_bit_firsthalf,class1_bit{i});
end
class1_bit_secondhalf=class1_bit{half1(2)+1};
for i=half1(2)+2:end1(2)
class1_bit_secondhalf=cat(1,class1_bit_secondhalf,class1_bit{i});
end


end2=size(class2_bit);
half2=size(class2_bit)/2;

class2_bit_firsthalf=class2_bit{1};
for i=2:half2(2)
class2_bit_firsthalf=cat(1,class2_bit_firsthalf,class2_bit{i});
end
class2_bit_secondhalf=class2_bit{half2(2)+1};
for i=half2(2)+2:end2(2)
class2_bit_secondhalf=cat(1,class2_bit_secondhalf,class2_bit{i});
end

TH=cat(1,class1_bit_firsthalf,class2_bit_firsthalf);
%elvart kimenetek a tanulo hamazra [1  1 0]=class1;[1  0 1]=class2
%elvart kimeneti halmaz generalasa
bias=ones(size(class1_bit_firsthalf)+size(class2_bit_firsthalf));

d_class1=cat(2,ones(size(class1_bit_firsthalf)),zeros(size(class1_bit_firsthalf)));
d_class2=cat(2,zeros(size(class2_bit_firsthalf)),ones(size(class2_bit_firsthalf)));

d_class=cat(1,d_class1,d_class2);
d_TH=cat(2,bias,d_class);

u=0.9; %tanulasi egyutthato

N=[numrows*numcols,2]; %bemenetek-kimenetek szama

%teszt halmaz
TH_Teszt=cat(1,class1_bit_secondhalf,class2_bit_secondhalf);


%elvart kimenetek a teszt hamazra
bias=ones(size(class1_bit_secondhalf)+size(class2_bit_secondhalf));

d_class1=cat(2,ones(size(class1_bit_secondhalf)),zeros(size(class1_bit_secondhalf)));
d_class2=cat(2,zeros(size(class2_bit_secondhalf)),ones(size(class2_bit_secondhalf)));

d_class=cat(1,d_class1,d_class2);
d_TH_Teszt=cat(2,bias,d_class);

w=(rand(N(1),N(2))-0.5)*0.1; %-s�lyzok kezdeti �rt�k�nek inicializ�l�sa

%t -tan�t�si ciklusoknak a sz�ma
t=10;

	for i=1:t
	ETH(i)=0;
    [mt, nt] = size(TH);
	for j=1:mt	%a j-ik elem kiv�laszt�sa a tan�t�halmazb�l@
	x=TH(j,:)'; 
	s=w'*x;		%az inger kisz�mol�sa
	y=sa(s);		%a h�l� kimenet�nek a kisz�mol�sa
	h=d_TH(j,:)'-y;	%a hiba kisz�mol�sa
	w=w+u*x*(h.*dsa(s))';		%a s�lyzok tan�t�sa
	ETH(i)=ETH(i)+h'*h;	%a hiba �sszegz�se egy tan�t�si ciklusra. A hib�t egy vektorban t�roljuk, a vektor minden egyes eleme egyes tan�t�si ciklusokban kapott hib�kat tartalmazz�k. Grafikusan �br�zolva a hib�t k�vetkeztetni lehet a h�l� tanul�s�nak alakul�s�ra
    tm=i;
    end    
    [mteszt, nteszt] = size(TH_Teszt);
    ETH_Teszt(i)=0;
	for j=1:mteszt
        x=TH_Teszt(j,:)'; %a j-ik elem kiv�laszt�sa a tan�t�halmazb�l
        s=w'*x;		%az inger kisz�mol�sa
        y=sa(s);	%a h�l� kimenet�nek a kisz�mol�sa
        h=d_TH_Teszt(j,:)'-y;
        ETH_Teszt(i)=ETH_Teszt(i)+h'*h;
    end    
	end
