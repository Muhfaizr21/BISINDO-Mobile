package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	"backend/internal/config"
	"backend/internal/controllers"
	"backend/internal/middleware"
	"backend/internal/repositories"
	"backend/internal/routes"
	"backend/internal/services"
	"backend/internal/supabase"
)

func main() {
	cfg := config.LoadConfig()

	log.Printf("Starting Sign Language Translator Backend on port %s", cfg.Port)
	log.Printf("Connecting to Supabase at: %s", cfg.SupabaseURL)

	supabaseClient := supabase.NewClient(cfg)
	historyRepo := repositories.NewSupabaseHistoryRepository(supabaseClient)
	learnRepo := repositories.NewSupabaseLearnRepository(supabaseClient)

	historyService := services.NewHistoryService(historyRepo)
	learnService := services.NewLearnService(learnRepo)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	sbHealth := supabaseClient.CheckHealth(ctx)
	if sbHealth.Connected {
		log.Printf("Supabase status: connected (Auth: %s, REST: %s)", sbHealth.AuthService, sbHealth.RESTService)
	} else {
		log.Printf("Supabase warning: %s", sbHealth.Error)
	}

	healthCtrl := controllers.NewHealthController(supabaseClient)
	historyCtrl := controllers.NewHistoryController(historyService)
	learnCtrl := controllers.NewLearnController(learnService)

	router := routes.SetupRoutes(routes.RouterParams{
		HealthController:  healthCtrl,
		HistoryController: historyCtrl,
		LearnController:   learnCtrl,
	})

	handler := middleware.EnableCORS(router)

	serverAddr := fmt.Sprintf(":%s", cfg.Port)
	log.Printf("Server listening on http://localhost%s", serverAddr)

	if err := http.ListenAndServe(serverAddr, handler); err != nil {
		log.Fatalf("Server stopped: %v", err)
	}
}
