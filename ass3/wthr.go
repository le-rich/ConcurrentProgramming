package main

import (
	"net/http"
	"os"
	"io/ioutil"
	"fmt"
	"sync"
	"sort"
	"strings"
	"encoding/json"
)

var wg sync.WaitGroup


type State struct {
	m *sync.Mutex
	results []string
}

func NewState() *State{
	s:= new (State)
	s.m = new(sync.Mutex)
	s.results = make([]string, 0)
	return s
}

func makeRequest(state *State, location string, apiKey string){
	resp, err := http.Get("https://api.openweathermap.org/data/2.5/weather?q=" + location + "&appid=" + apiKey + "&units=metric")
	if err != nil {
		fmt.Println("Get Request Error For: " + location)
		return
	}
	defer resp.Body.Close()
	bodyBytes, err := ioutil.ReadAll(resp.Body)
	
	var dat map[string]interface{}

	err2 := json.Unmarshal(bodyBytes, &dat)
	if err != nil {
		fmt.Println(err2)
		return
	}
	var weather = dat["weather"].([]interface{})
	var weatherBody = weather[0].(map[string]interface{})
	var description = weatherBody["description"].(string)

	var main = dat["main"].(map[string]interface{})
	var temp = main["temp"].(float64)
	var humidity = main["humidity"].(float64)
	state.m.Lock()
	state.results = append(state.results, (strings.ToLower(location) + ": " + fmt.Sprintf("%.2f", temp) + " deg C, " + fmt.Sprintf("%.2f", humidity) + "%," + description))
	state.m.Unlock()
	wg.Done()
}

func main() {
	locations := os.Args[1:]
	data, err := ioutil.ReadFile("key.txt")
	s := NewState()
	if err != nil {
		fmt.Println("File reading error", err)
		return
	}
	for _, location := range locations{
		go makeRequest(s, string(location), string(data))
		wg.Add(1)
	}

	wg.Wait()
	sort.Strings(s.results)
	for _, result := range s.results {
		fmt.Println(result)
	}
}
