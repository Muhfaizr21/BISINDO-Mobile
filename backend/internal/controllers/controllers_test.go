package controllers_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"backend/internal/controllers"
	"backend/internal/models"
	"backend/internal/repositories"
	"backend/internal/services"
)

type mockSupabaseService struct{}

func (m *mockSupabaseService) CheckHealth(ctx context.Context) models.SupabaseHealth {
	return models.SupabaseHealth{
		Connected:   true,
		URL:         "https://test.supabase.co",
		AuthService: "healthy",
		RESTService: "healthy",
	}
}

func (m *mockSupabaseService) QueryREST(ctx context.Context, method, endpoint string, body any) ([]byte, int, error) {
	return []byte("[]"), http.StatusOK, nil
}

func TestHealthController(t *testing.T) {
	mockSb := &mockSupabaseService{}
	ctrl := controllers.NewHealthController(mockSb)

	req := httptest.NewRequest("GET", "/api/health", nil)
	w := httptest.NewRecorder()

	ctrl.CheckHealth(w, req)

	if w.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", w.Code)
	}

	var res models.SystemHealth
	if err := json.Unmarshal(w.Body.Bytes(), &res); err != nil {
		t.Fatalf("failed to decode response: %v", err)
	}

	if res.Status != "healthy" {
		t.Errorf("expected status 'healthy', got %s", res.Status)
	}
	if !res.Supabase.Connected {
		t.Error("expected Supabase to be connected")
	}
}

func TestHistoryController(t *testing.T) {
	repo := repositories.NewMemoryHistoryRepository()
	service := services.NewHistoryService(repo)
	ctrl := controllers.NewHistoryController(service)

	// Test GET
	req := httptest.NewRequest("GET", "/api/history", nil)
	w := httptest.NewRecorder()
	ctrl.GetHistory(w, req)

	if w.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", w.Code)
	}

	// Test POST
	body := bytes.NewBufferString(`{"text":"Test Gesture Result"}`)
	postReq := httptest.NewRequest("POST", "/api/history", body)
	postW := httptest.NewRecorder()
	ctrl.CreateHistory(postW, postReq)

	if postW.Code != http.StatusCreated {
		t.Fatalf("expected status 201, got %d", postW.Code)
	}
}

