package main

import (
  "encoding/json"
  "os"
  "log"
  "fmt"
)

// only exported names are encoded
type Name struct {
  First  string  `json:"first"`  // tag
  Middle string  `json:"middle"`
  Last   string  `json:"last"`
}

type Student struct {
  Id     string  `json:"id"`
  Name   Name    `json:"name"`
  Score  int     `json:"score"`
}

func main() {
  var rs []Student

  f, err := os.Open("data2")
  if err != nil {
    // log.Fatal(err)
    fmt.Fprintf(os.Stderr, "unable to open file\n")
    os.Exit(1)
  }

  err = json.NewDecoder(f).Decode(&rs)
  if err != nil {
    log.Fatal(err)
  }

  fmt.Println(rs)
}

