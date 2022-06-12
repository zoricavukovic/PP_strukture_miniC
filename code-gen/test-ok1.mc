//OPIS: jedna globalna promenljiva
//RETURN: 11

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
  //osoba1.visina = 10;
  //osoba2.tezina = 8;
  a = osoba1.visina + 11;
  b = osoba2.tezina;
  
  return a + b;
}




