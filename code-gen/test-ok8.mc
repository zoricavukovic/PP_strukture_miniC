//OPIS: drugi nacin inicijalizacije strukture
//RETURN: 56

struct person {
   int tezina;
   int godine;
   unsigned visina;
};

struct car {
  unsigned engine;
  int godine;
};

struct person osoba1;

struct person osoba4 = {
	2,
	3,
	4u
};
struct car auto1;
struct person osoba2;

unsigned main() {
  
  int a;
  unsigned b;
  a = 11;
  auto1.engine = 40u;
  b = auto1.engine;
  b = b + osoba4.visina + 12u;
  
  return b;
}

