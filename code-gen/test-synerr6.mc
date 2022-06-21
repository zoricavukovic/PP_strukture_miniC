//OPIS: neispavna dodela vrednosti atributa pri inicijalizaciji strukture

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

struct person osoba4 = {
	2, 
	3,
};
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
  a = osoba4.tezina + auto1.godine + a;
  
  return a;
}

