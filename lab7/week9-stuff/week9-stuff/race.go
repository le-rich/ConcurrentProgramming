package main

import (
  "fmt"
  "sync"
)

var wg sync.WaitGroup

func inc(count *int) {
  defer wg.Done()
  for i := 0; i < 1000000; i++ {
    (*count)++
  }
}

func main() {
  var count int = 0
  wg.Add(2)
  go inc(&count)
  go inc(&count)
  wg.Wait()
  fmt.Println(count)
}
