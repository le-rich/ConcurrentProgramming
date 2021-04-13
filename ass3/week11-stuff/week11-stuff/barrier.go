package main

import (
  "fmt"
  "math/rand"
  "time"
)

var start1, start2, done1 chan bool
var ans chan int

func worker() {
  <-start1
  // stage 1
  fmt.Println("starting stage 1")
  time.Sleep(time.Duration(1 + rand.Intn(10)) * time.Second)
  fmt.Println("finishing stage 1")
  done1 <- true

  <-start2
  fmt.Println("starting stage 2")
  // stage 2
  n := 1 + rand.Intn(10)
  time.Sleep(time.Duration(n) * time.Second)
  ans <- n
  fmt.Println(n)
}

func main() {
  start1 = make(chan bool)
  start2 = make(chan bool)
  done1 = make(chan bool)  // can also be buffered
  ans = make(chan int)     // can also be buffered

  rand.Seed(time.Now().UnixNano())
  // start workers
  for i := 0; i < 5; i++ {
    go worker()
  }
  close(start1)  // starts stage 1 for all workers

  // wait for stage 1 to finish
  for i := 0; i < 5; i++ {
    <-done1
  }

  close(start2)  // starts stage 2

  total := 0
  for i := 0; i < 5; i++ {
    total = total + <-ans
  }
  fmt.Println(total)
}
