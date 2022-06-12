//OPIS: koriscenje atributa strukture u okviru assignmenta i exp
//RETURN: 84

struct person {
   int tezina;
   int visina;
   int godine;
};

struct car {
  unsigned engine;
  int godine;
};

struct person osoba1;
struct car auto1;
struct person osoba2;

int main() {
  
  int a;
  unsigned b;
  a = 11;
  osoba1.tezina = 50;
  auto1.godine = 23;
  auto1.engine = 40u;
  b = auto1.engine;
  a = osoba1.tezina + auto1.godine + a;
  
  return a;
}




