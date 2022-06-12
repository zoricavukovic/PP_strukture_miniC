//OPIS: dodela razlicitih tipova u okviru exp
//RETURN: 11

struct person {
   int tezina;
   unsigned visina;
   int godine;
};

struct person osoba1;
struct person osoba2;

int main() {
  
  int a;
  int b;
  a = 11;
  osoba1.visina = 10u;
  b = osoba1.visina; //int tipu se dodeljuje vrednost atributa strukture tip unsigned !!!
  
  return a;
}
