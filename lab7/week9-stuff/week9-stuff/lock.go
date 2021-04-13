package main

import (
  "fmt"
  "sync"
)

var count int = 0
var wg sync.WaitGroup
var mutex sync.Mutex

func inc() {
  defer wg.Done()
  for i := 0; i < 1000000; i++ {
    mutex.Lock()
    count++
    mutex.Unlock()
  }
}

func main() {
  wg.Add(2)
  go inc()
  go inc()
  wg.Wait()
  fmt.Println(count)
}
