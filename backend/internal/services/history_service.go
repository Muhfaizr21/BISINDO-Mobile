package services

import (
	"context"
	"fmt"
	"time"

	"backend/internal/models"
	"backend/internal/repositories"
)

type HistoryService interface {
	FetchAll(ctx context.Context) ([]models.HistoryItem, error)
	AddHistory(ctx context.Context, req models.CreateHistoryRequest) (models.HistoryItem, error)
	RemoveHistory(ctx context.Context, id string) error
	ClearAll(ctx context.Context) error
}

type historyServiceImpl struct {
	repo repositories.HistoryRepository
}

func NewHistoryService(repo repositories.HistoryRepository) HistoryService {
	return &historyServiceImpl{repo: repo}
}

func (s *historyServiceImpl) FetchAll(ctx context.Context) ([]models.HistoryItem, error) {
	return s.repo.GetAll(ctx)
}

func (s *historyServiceImpl) AddHistory(ctx context.Context, req models.CreateHistoryRequest) (models.HistoryItem, error) {
	if req.Text == "" {
		return models.HistoryItem{}, fmt.Errorf("text cannot be empty")
	}

	id := req.ID
	if id == "" {
		id = fmt.Sprintf("hist-%d", time.Now().UnixNano())
	}

	item := models.HistoryItem{
		ID:        id,
		Text:      req.Text,
		Timestamp: time.Now().UTC(),
	}

	if err := s.repo.Create(ctx, item); err != nil {
		return models.HistoryItem{}, err
	}

	return item, nil
}

func (s *historyServiceImpl) RemoveHistory(ctx context.Context, id string) error {
	return s.repo.Delete(ctx, id)
}

func (s *historyServiceImpl) ClearAll(ctx context.Context) error {
	return s.repo.Clear(ctx)
}

