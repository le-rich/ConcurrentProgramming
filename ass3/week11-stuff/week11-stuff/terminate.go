package main

import (
  "fmt"
  "time"
  "math/rand"
)

// when 1 worker finds the answer, terminate them all
func worker(ans chan int, die chan bool) {
  for {
    select {
    case <-die:
      fmt.Println("terminating")
      return
    default:
      // simulate doing work
      n := 1 + rand.Intn(100)
      if n % 17 == 0 {
        ans <- n
      }
      time.Sleep(500 * time.Millisecond)
    }
  }
}

func main() {
  die := make(chan bool)  // channel to ask workers to die
  ans := make(chan int)   // channel for worker to send back the answer
  go worker(ans, die)
  go worker(ans, die)
  go worker(ans, die)
  x := <-ans
  close(die)
  time.Sleep(1 * time.Second)  // process answer
  fmt.Println(x)
}
