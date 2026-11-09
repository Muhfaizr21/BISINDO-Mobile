package repositories

import (
	"context"
	"sync"
	"time"

	"backend/internal/models"
)

type HistoryRepository interface {
	GetAll(ctx context.Context) ([]models.HistoryItem, error)
	Create(ctx context.Context, item models.HistoryItem) error
	Delete(ctx context.Context, id string) error
	Clear(ctx context.Context) error
}

type MemoryHistoryRepository struct {
	mu    sync.RWMutex
	items []models.HistoryItem
}

func NewMemoryHistoryRepository() *MemoryHistoryRepository {
	return &MemoryHistoryRepository{
		items: []models.HistoryItem{
			{
				ID:        "sample-1",
				Text:      "Halo selamat datang di Sign Language App",
				Timestamp: time.Now().Add(-1 * time.Hour),
			},
			{
				ID:        "sample-2",
				Text:      "Terima kasih",
				Timestamp: time.Now().Add(-30 * time.Minute),
			},
		},
	}
}

func (r *MemoryHistoryRepository) GetAll(ctx context.Context) ([]models.HistoryItem, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	result := make([]models.HistoryItem, len(r.items))
	copy(result, r.items)
	return result, nil
}

func (r *MemoryHistoryRepository) Create(ctx context.Context, item models.HistoryItem) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	r.items = append([]models.HistoryItem{item}, r.items...)
	return nil
}

func (r *MemoryHistoryRepository) Delete(ctx context.Context, id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	for i, item := range r.items {
		if item.ID == id {
			r.items = append(r.items[:i], r.items[i+1:]...)
			break
		}
	}
	return nil
}

func (r *MemoryHistoryRepository) Clear(ctx context.Context) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	r.items = []models.HistoryItem{}
	return nil
}

