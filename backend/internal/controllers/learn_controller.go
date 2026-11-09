package controllers

import (
	"net/http"

	"backend/internal/services"
	"backend/internal/views"
)

type LearnController struct {
	learnService services.LearnService
}

func NewLearnController(ls services.LearnService) *LearnController {
	return &LearnController{learnService: ls}
}

func (c *LearnController) GetMaterials(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	materials, err := c.learnService.FetchMaterials(ctx)
	if err != nil {
		views.RenderError(w, http.StatusInternalServerError, "Failed to fetch learn materials", err.Error())
		return
	}

	views.RenderJSON(w, http.StatusOK, materials)
}

