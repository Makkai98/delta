# delta

Feladat
1. Válasszon ki n >= 2 osztályt http://www.vision.caltech.edu/Image_Datasets/Caltech101
adathalmazból. Egyréteg ˝u neuronhálót használva írjon osztályozót, amely szétválasztja a különböz˝o
osztályokat. Négyzetes hibafüggvényt használjon.
2. Jelenítse meg grafikusan a tesztelési halmaz egy részét az osztályozó kimenetével.
3. Jelenítse meg a konfúziós mátrixot.


A feladat megoldás során felmerült problémák és megoldásaik: 
	-A képek nem egyforma méretűek => képek átméretese egységes méretre
	-RGB 3 matrixa helyett eleg csak 1 matrixot hasznalni, ezert atalakitottam szurkere a kepet
	-Atalakitottam a kepmatrixokat bitmatrixokka
	-kepmatrixok osszefuzese a tanito es teszthalmaz letrehozasara
	-elvart kimeneti halmazok generalasa
