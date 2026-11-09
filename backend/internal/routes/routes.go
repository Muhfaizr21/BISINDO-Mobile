package routes

import (
	"net/http"

	"backend/internal/controllers"
)

type RouterParams struct {
	HealthController  *controllers.HealthController
	HistoryController *controllers.HistoryController
	LearnController   *controllers.LearnController
}

func SetupRoutes(params RouterParams) *http.ServeMux {
	mux := http.NewServeMux()

	// Health Check & Supabase Connection Check
	mux.HandleFunc("GET /health", params.HealthController.CheckHealth)
	mux.HandleFunc("GET /api/health", params.HealthController.CheckHealth)

	// History Management
	mux.HandleFunc("GET /api/history", params.HistoryController.GetHistory)
	mux.HandleFunc("POST /api/history", params.HistoryController.CreateHistory)
	mux.HandleFunc("DELETE /api/history", params.HistoryController.ClearHistory)

	// Learn Catalog
	mux.HandleFunc("GET /api/learn", params.LearnController.GetMaterials)

	return mux
}

