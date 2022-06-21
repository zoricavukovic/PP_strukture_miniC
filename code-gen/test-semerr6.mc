//OPIS: pristupanje atributu strukture tipa person koji nije definisan za datu strukturu

struct person {
   int tezina;
   int visina;
   int godine;
};

struct person osoba1;
struct person osoba2;

int main() {
  
  int a;
  int b;
  a = 11;
  osoba1.visina = 10;
  osoba2.nesto = 8;
  
  return a;
}
