package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Handling request...")
		_, _ = fmt.Fprintf(w, "%s: Hello world!", time.Now().Format(time.DateTime))
	})

	log.Printf("Starting webserver on http://localhost:8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err.Error())
	}
	log.Printf("Finished")
}
