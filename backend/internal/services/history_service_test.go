package services_test

import (
	"context"
	"testing"

	"backend/internal/models"
	"backend/internal/repositories"
	"backend/internal/services"
)

func TestHistoryService_AddAndFetch(t *testing.T) {
	repo := repositories.NewMemoryHistoryRepository()
	service := services.NewHistoryService(repo)

	ctx := context.Background()

	// Initial samples exist
	initialItems, err := service.FetchAll(ctx)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	initialCount := len(initialItems)

	// Add item
	newItem, err := service.AddHistory(ctx, models.CreateHistoryRequest{
		Text: "Tes Isyarat Tangan",
	})
	if err != nil {
		t.Fatalf("failed to add history: %v", err)
	}

	if newItem.Text != "Tes Isyarat Tangan" {
		t.Errorf("expected text 'Tes Isyarat Tangan', got %s", newItem.Text)
	}

	// Verify count increased
	items, err := service.FetchAll(ctx)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(items) != initialCount+1 {
		t.Errorf("expected %d items, got %d", initialCount+1, len(items))
	}
}

func TestHistoryService_Validation(t *testing.T) {
	repo := repositories.NewMemoryHistoryRepository()
	service := services.NewHistoryService(repo)

	ctx := context.Background()

	_, err := service.AddHistory(ctx, models.CreateHistoryRequest{
		Text: "",
	})
	if err == nil {
		t.Error("expected error for empty text, got nil")
	}
}

