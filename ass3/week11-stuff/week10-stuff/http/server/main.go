package main

import (
  "localhost/studentsvr"
  "log"
)

func main() {
  s := studentsvr.NewHTTPServer(":8000")
  log.Fatal(s.ListenAndServe())
}
