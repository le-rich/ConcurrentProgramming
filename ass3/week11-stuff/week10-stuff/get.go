package main

import (
  "net/http"
  "io"
  "fmt"
  "log"
)

func getPageSize(url string) (int, error) {
  resp, err := http.Get(url)
  if err != nil {
    return 0, err
  }

  defer resp.Body.Close()
  body, err := io.ReadAll(resp.Body)
  if err != nil {
    return 0, err
  }

  return len(body), nil
}

func main() {
  size, err := getPageSize("http://www.bcit.ca")
  if err != nil {
    log.Fatal(err)
  }
  fmt.Println(size)
}
