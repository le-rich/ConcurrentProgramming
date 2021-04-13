/* compile with -pthread */
#include <pthread.h>
#include <stdio.h>

unsigned long count = 0;

void *f(void *arg) {
  int  i;
  for (i = 0; i < 1000000; i++)
    count++;
}

int main() {
  pthread_t  tid1, tid2;

  pthread_create(&tid1, 0, f, 0);
  pthread_create(&tid2, 0, f, 0);
  pthread_join(tid1, 0);
  pthread_join(tid2, 0);
  printf("%lu\n", count);  
  return 0;
}
