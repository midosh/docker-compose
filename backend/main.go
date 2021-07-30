package main

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Println(r.URL.RawQuery)
	fmt.Fprintf(w, `
                    .-"""-.
                   / .===. \
                   \/ 6 6 \/
                   ( \___/ )
      _________ooo__\_____/______________
     /                                   \
    |           Ahmed Ramadan             |
    |            FOLLOW ME :              |
    |    www.linkedin.com/in/arsharaf/    |
     \_______________________ooo_________/  
                    |  |  |
                    |_ | _|
                    |  |  |
                    |__|__|
                    /-'Y'-\
                   (__/ \__)
`)
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":80", nil))
}