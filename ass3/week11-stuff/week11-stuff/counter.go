package main

import (
  "fmt"
)

func inc(count *int, c, done chan bool) {
  for i := 0; i < 1000000; i++ {
    <-c
    (*count)++
    c <- true
  }
  done <- true  // analogous to wg.Done()
}

func main() {
  var count int = 0
  c := make(chan bool, 1)
  c <- true
  done := make(chan bool, 2)  // used as a WaitGroup; buffered so as not
                              // to block a goroutine from finishing when
                              // writing to it; unbuffered also works
  go inc(&count, c, done)
  go inc(&count, c, done)
  _, _ = <-done, <-done       // analogous to wg.Wait()
  fmt.Println(count)
}
