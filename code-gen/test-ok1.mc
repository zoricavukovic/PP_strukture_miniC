//OPIS: koriscenje atributa strukture u okviru assignmenta i exp
//RETURN: 21

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
  
  a = osoba1.visina + 11;
  b = osoba2.tezina;
  
  return a + b;
}




