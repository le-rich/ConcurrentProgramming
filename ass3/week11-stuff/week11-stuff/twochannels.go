// reading from 2 channels until both are closed
package main

import (
  "fmt"
  "time"
  "math/rand"
)

func worker(c1, c2 chan int, done chan bool) {
  for {
    select {
    case x, ok := <-c1:
      if !ok {
        c1 = nil  // nil channel always blocks
      } else {
        fmt.Printf("c1: %d\n", x)
      }
    case x, ok := <-c2:
      if !ok {
        c2 = nil  // nil channel always blocks
      } else {
        fmt.Printf("c2: %d\n", x)
      }
    }
    if c1 == nil && c2 == nil {
      close(done)
      return
    }
  }
}

func generate(c chan int, n int) {
  for i := 0; i < n; i++ {
    c <- rand.Intn(1000)
    time.Sleep(500 * time.Millisecond)
  }
  close(c)
}

func main() {
  done := make(chan bool)
  c1 := make(chan int)
  c2 := make(chan int)
  go worker(c1, c2, done)
  go generate(c1, 20)
  go generate(c2, 30)
  <-done
}
