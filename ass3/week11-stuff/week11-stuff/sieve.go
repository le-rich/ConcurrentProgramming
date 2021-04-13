// example from one of the creators of Go 
package main

import "fmt"

func filter(prime int, in chan int, out chan int) {
  for {
    x := <-in
    if x % prime != 0 {
      out <- x
    }
  }
}

func generate(c chan int) {
  for i := 2; ; i++ {
    c <- i
  }
}

func main() {
  in := make(chan int)
  go generate(in)

  for i := 0; i < 100; i++ {
    prime := <-in
    fmt.Println(prime)
    out := make(chan int)
    go filter(prime, in, out)
    in = out
  }
}
