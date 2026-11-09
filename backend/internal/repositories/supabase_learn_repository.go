package repositories

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

	"backend/internal/models"
	"backend/internal/supabase"
)

type SupabaseLearnRepository struct {
	client   supabase.Client
	fallback *DefaultLearnRepository
}

func NewSupabaseLearnRepository(client supabase.Client) *SupabaseLearnRepository {
	return &SupabaseLearnRepository{
		client:   client,
		fallback: NewDefaultLearnRepository(),
	}
}

func (r *SupabaseLearnRepository) GetMaterials(ctx context.Context) ([]models.LearnItem, error) {
	data, statusCode, err := r.client.QueryREST(ctx, "GET", "learn_materials?select=*&order=id.asc", nil)
	if err != nil || statusCode != http.StatusOK {
		log.Printf("Supabase learn_materials failed (status %d): %v; using fallback default materials", statusCode, err)
		return r.fallback.GetMaterials(ctx)
	}

	var items []models.LearnItem
	if err := json.Unmarshal(data, &items); err != nil || len(items) == 0 {
		return r.fallback.GetMaterials(ctx)
	}
	return items, nil
}
