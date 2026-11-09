package views

import (
	"encoding/json"
	"net/http"
)

type APIResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message,omitempty"`
	Data    any    `json:"data,omitempty"`
	Error   string `json:"error,omitempty"`
}

// RenderJSON writes a standardized JSON response
func RenderJSON(w http.ResponseWriter, statusCode int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	_ = json.NewEncoder(w).Encode(data)
}

// RenderSuccess writes a standardized success JSON response
func RenderSuccess(w http.ResponseWriter, statusCode int, message string, data any) {
	RenderJSON(w, statusCode, APIResponse{
		Success: true,
		Message: message,
		Data:    data,
	})
}

// RenderError writes a standardized error JSON response
func RenderError(w http.ResponseWriter, statusCode int, message string, errDetail string) {
	RenderJSON(w, statusCode, APIResponse{
		Success: false,
		Message: message,
		Error:   errDetail,
	})
}

