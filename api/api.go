package api

import (
	"encoding/json"
	"net/http"
)

type ApiImpl struct{}

// Make sure we conform to ServerInterface
var _ ServerInterface = (*ApiImpl)(nil)

func NewApiImpl() *ApiImpl {
	return &ApiImpl{}
}

func (*ApiImpl) GetStatus(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	resp := &Status{Id: "OK"}
	writer := json.NewEncoder(w)
	if err := writer.Encode(resp); err != nil {
		panic(err)
	}
}
