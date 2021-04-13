package main

import (
  "net/http"
  "fmt"
  "log"
  "sync"
)

type Counter struct {
  mut    sync.Mutex
  count  int
}

func (c *Counter) ServeHTTP(w http.ResponseWriter, r *http.Request) {
  c.mut.Lock()
  defer c.mut.Unlock()
  c.count++
  fmt.Fprintf(w, "%d\n", c.count)
}

func main() {
  http.Handle("/counter", new(Counter))

  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Println(r)
  })

  log.Fatal(http.ListenAndServe(":8080", nil))
}
