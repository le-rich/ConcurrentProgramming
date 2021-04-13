package main

import (
  "encoding/json"
  "os"
  "log"
)

// only exported names are encoded
type Name struct {
  First  string  `json:"first"`  // tag
  Last   string  `json:"last"`
}

type Student struct {
  Id     string  `json:"id"`
  Name   Name    `json:"name"`
  Score  int     `json:"score"`

}

func main() {
  rs := []Student {
    Student{Id: "a12345678", Name: Name{First: "homer", Last: "simpson"}, Score: 45},
    Student{"a66666666", Name{"monty", "burns"}, 90},
  }
  err := json.NewEncoder(os.Stdout).Encode(rs)
  if err != nil {
    log.Fatal(err)
  }
}

