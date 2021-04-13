package main

import (
  "bufio"
  "os"
  "fmt"
)

func main() {
  count := 0
  scanner := bufio.NewScanner(os.Stdin)
  scanner.Split(bufio.ScanBytes)
  for scanner.Scan() {
    switch scanner.Text() {
    case "+": count++
    case "-": count--
    }
    if count < 0 || count > 1000 {
      fmt.Println("error")
    }
  }
}
