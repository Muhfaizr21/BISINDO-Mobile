package controllers

import (
	"net/http"
	"time"

	"backend/internal/models"
	"backend/internal/supabase"
	"backend/internal/views"
)

type HealthController struct {
	supabaseClient supabase.Client
}

func NewHealthController(sc supabase.Client) *HealthController {
	return &HealthController{supabaseClient: sc}
}

func (c *HealthController) CheckHealth(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	sbHealth := c.supabaseClient.CheckHealth(ctx)

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

