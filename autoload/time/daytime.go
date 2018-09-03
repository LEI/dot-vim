//usr/bin/env go run "$0" "$@" ; exit "$?"
package main

import (
	"fmt"
	"log"
	"time"
)

// http://edwilliams.org/sunrise_sunset_algorithm.htm

var (
	// location *time.Location
	format = "2006-01-02T15:04:05Z0700"
	zone   = "Europe/Paris"
)

func main() {
	location, err := time.LoadLocation(zone)
	if err != nil {
		log.Fatalf("failed to load location %s: %s", zone, err)
	}
	now := time.Now()
	localizedTime := now.In(location)
	fmt.Println(localizedTime.Format(format))
	// fmt.Printf("loc %+v\n", localizedTime.Location())
	// fmt.Printf("time %+v\n", localizedTime)
	// os.Exit(2)
}
