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
)

func main() {
	// 1. Load Configuration
	cfg := config.LoadConfig()

	log.Println("==================================================")
	log.Println("  Sign Language Translator Backend (Go + Supabase)")
	log.Println("  Architecture: MVC (Model-View-Controller) + SOLID")
	log.Println("==================================================")
	log.Printf("Connecting to Supabase at: %s", cfg.SupabaseURL)

	// 2. Initialize Services & Repositories (DIP / SRP)
	supabaseService := services.NewSupabaseService(cfg)
	historyRepo := repositories.NewMemoryHistoryRepository()
	learnRepo := repositories.NewDefaultLearnRepository()

	historyService := services.NewHistoryService(historyRepo)
	learnService := services.NewLearnService(learnRepo)

	// Verify Supabase Connection on startup
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	sbHealth := supabaseService.CheckHealth(ctx)
	if sbHealth.Connected {
		log.Printf("[SUCCESS] Supabase Connected! Auth: %s | REST: %s", sbHealth.AuthService, sbHealth.RESTService)
	} else {
		log.Printf("[WARNING] Supabase Check: %s", sbHealth.Error)
	}

	// 3. Initialize Controllers
	healthCtrl := controllers.NewHealthController(supabaseService)
	historyCtrl := controllers.NewHistoryController(historyService)
	learnCtrl := controllers.NewLearnController(learnService)

	// 4. Setup Routes (Routing layer)
	router := routes.SetupRoutes(routes.RouterParams{
		HealthController:  healthCtrl,
		HistoryController: historyCtrl,
		LearnController:   learnCtrl,
	})

	// 5. Middleware (CORS)
	handler := middleware.EnableCORS(router)

	serverAddr := fmt.Sprintf(":%s", cfg.Port)
	log.Printf("Server listening on http://localhost%s", serverAddr)
	log.Printf("Health Check: http://localhost%s/api/health", serverAddr)
	log.Printf("History API:  http://localhost%s/api/history", serverAddr)
	log.Printf("Learn API:    http://localhost%s/api/learn", serverAddr)

	if err := http.ListenAndServe(serverAddr, handler); err != nil {
		log.Fatalf("Server stopped: %v", err)
	}
}
