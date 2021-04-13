package main

import (
  "fmt"
  "sync"
  "sync/atomic"
)

var count int32 = 0
var wg sync.WaitGroup

func inc() {
  defer wg.Done()
  for i := 0; i < 1000000; i++ {
    atomic.AddInt32(&count, 1)
  }
}

func main() {
  wg.Add(2)
  go inc()
  go inc()
  wg.Wait()
  fmt.Println(count)
}
