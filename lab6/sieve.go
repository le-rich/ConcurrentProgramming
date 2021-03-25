package main

import "fmt"

func sieve(size int) []bool {
  s := make([]bool, size)
  for i := 2; i < size; i++ {
    s[i] = true
  }

  for i := 2; i * i < size; i++ {
    if s[i] {
      for j := i * i; j < size; j += i {
        s[j] = false
      }
    }
  }

  return s
}

func main() {
  s := sieve(100)
  for i := 2; i < 100; i++ {
    if s[i] {
      fmt.Println(i)
    }
  }
}
