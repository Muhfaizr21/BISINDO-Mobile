package repositories

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/url"

	"backend/internal/models"
	"backend/internal/supabase"
)

type SupabaseHistoryRepository struct {
	client   supabase.Client
	fallback *MemoryHistoryRepository
}

func NewSupabaseHistoryRepository(client supabase.Client) *SupabaseHistoryRepository {
	return &SupabaseHistoryRepository{
		client:   client,
		fallback: NewMemoryHistoryRepository(),
	}
}

func (r *SupabaseHistoryRepository) GetAll(ctx context.Context) ([]models.HistoryItem, error) {
	data, statusCode, err := r.client.QueryREST(ctx, "GET", "history?select=*&order=timestamp.desc", nil)
	if err != nil || statusCode != http.StatusOK {
		log.Printf("Supabase history GetAll failed (status %d): %v; using fallback memory store", statusCode, err)
		return r.fallback.GetAll(ctx)
	}

	var items []models.HistoryItem
	if err := json.Unmarshal(data, &items); err != nil {
		log.Printf("Supabase unmarshal error: %v; using fallback", err)
		return r.fallback.GetAll(ctx)
	}
	return items, nil
}

func (r *SupabaseHistoryRepository) Create(ctx context.Context, item models.HistoryItem) error {
	_, statusCode, err := r.client.QueryREST(ctx, "POST", "history", item)
	if err != nil || (statusCode != http.StatusOK && statusCode != http.StatusCreated) {
		log.Printf("Supabase history Create failed (status %d): %v; using fallback memory store", statusCode, err)
		return r.fallback.Create(ctx, item)
	}
	_ = r.fallback.Create(ctx, item)
	return nil
}

func (r *SupabaseHistoryRepository) Delete(ctx context.Context, id string) error {
	endpoint := fmt.Sprintf("history?id=eq.%s", url.QueryEscape(id))
	_, statusCode, err := r.client.QueryREST(ctx, "DELETE", endpoint, nil)
	if err != nil || (statusCode != http.StatusOK && statusCode != http.StatusNoContent) {
		log.Printf("Supabase history Delete failed (status %d): %v; using fallback memory store", statusCode, err)
		return r.fallback.Delete(ctx, id)
	}
	_ = r.fallback.Delete(ctx, id)
	return nil
}

func (r *SupabaseHistoryRepository) Clear(ctx context.Context) error {
	_, statusCode, err := r.client.QueryREST(ctx, "DELETE", "history?id=neq.empty", nil)
	if err != nil || (statusCode != http.StatusOK && statusCode != http.StatusNoContent) {
		log.Printf("Supabase history Clear failed (status %d): %v; using fallback memory store", statusCode, err)
		return r.fallback.Clear(ctx)
	}
	_ = r.fallback.Clear(ctx)
	return nil
}
