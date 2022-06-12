# Implementacija struktura u miniC jeziku
Projekat je rađen na Linux operativnom sistemu, a od alata koje je neophodno da imate kako bi uspešno pokrenuli ovaj kod su Flex, Bison, GCC i GNU make. 
Što se samog kompajliranja i pokretanja testnih primera tiče, moguće je u folderu gde se nalaze sve datoteke, otvoriti terminal i pokrenuti komandu 
    -- make test (ona nam samo daje odgovor na pitanje da li su naši testovi prošli ili ne). 

Pored ove komande, ukoliko želimo možda nešto više da saznamo o dobijenoj grešci možemo da pokrenemo
    -- make det (ova komanda nam daje malo detaljniji opis greške na koju smo naišli)

Što se tiče generisanja koda, ukoliko vidimo da imamo grešku tokom pokretanja prethodne dve komande, moguće je da kroz simulator vidimo na koji način je izgenerisan naš kod i kako on zaista funksioniše. To je omogućeno pokretanjem sledeće komande
    -- ./hipsim < naziv_test_fajla.asm