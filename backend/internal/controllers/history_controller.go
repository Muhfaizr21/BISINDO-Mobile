package controllers

import (
	"encoding/json"
	"net/http"

	"backend/internal/models"
	"backend/internal/services"
	"backend/internal/views"
)

type HistoryController struct {
	historyService services.HistoryService
}

func NewHistoryController(hs services.HistoryService) *HistoryController {
	return &HistoryController{historyService: hs}
}

func (c *HistoryController) GetHistory(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	items, err := c.historyService.FetchAll(ctx)
	if err != nil {
		views.RenderError(w, http.StatusInternalServerError, "Failed to fetch history", err.Error())
		return
	}

	views.RenderJSON(w, http.StatusOK, items)
}

func (c *HistoryController) CreateHistory(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	var req models.CreateHistoryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		views.RenderError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	item, err := c.historyService.AddHistory(ctx, req)
	if err != nil {
		views.RenderError(w, http.StatusBadRequest, "Failed to save history", err.Error())
		return
	}

	views.RenderJSON(w, http.StatusCreated, item)
}

func (c *HistoryController) ClearHistory(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if err := c.historyService.ClearAll(ctx); err != nil {
		views.RenderError(w, http.StatusInternalServerError, "Failed to clear history", err.Error())
		return
	}

	views.RenderSuccess(w, http.StatusOK, "History cleared successfully", nil)
}

