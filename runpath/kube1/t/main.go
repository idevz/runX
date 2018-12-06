package main

import (
	"io"
	"net/http"
)

// CGO_ENABLED=0 GOARCH="amd64" GOOS="linux" go build -a -installsuffix cgo -o k8s_test_server
func main() {
	http.HandleFunc("/idevz", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "ok->idevz")
	})
	http.HandleFunc("/zj", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "zj->ok")
	})
	go http.ListenAndServe(":8888", nil)
	http.ListenAndServeTLS(":8443", "server.crt", "server.key", nil)
}
