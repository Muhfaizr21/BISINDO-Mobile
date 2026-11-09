package controllers

import (
	"net/http"
	"time"

	"backend/internal/models"
	"backend/internal/services"
	"backend/internal/views"
)

type HealthController struct {
	supabaseService services.SupabaseService
}

func NewHealthController(ss services.SupabaseService) *HealthController {
	return &HealthController{supabaseService: ss}
}

func (c *HealthController) CheckHealth(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	sbHealth := c.supabaseService.CheckHealth(ctx)

	overallStatus := "healthy"
	if !sbHealth.Connected {
		overallStatus = "degraded"
	}

	response := models.SystemHealth{
		Status:    overallStatus,
		Service:   "sign-language-translator-backend",
		Runtime:   "golang",
		Timestamp: time.Now().UTC(),
		Supabase:  sbHealth,
	}

	views.RenderJSON(w, http.StatusOK, response)
}

