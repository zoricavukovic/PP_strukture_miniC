//OPIS: dodela razlicitih tipova u okviru assignmenta
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
  osoba1.visina = 10; //unsigned tipu se dodeljuje tip int !!!
  
  return a;
}
