package supabase

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"backend/internal/config"
	"backend/internal/models"
)

type Client interface {
	CheckHealth(ctx context.Context) models.SupabaseHealth
	QueryREST(ctx context.Context, method, endpoint string, body any) ([]byte, int, error)
}

type clientImpl struct {
	cfg        *config.Config
	httpClient *http.Client
}

func NewClient(cfg *config.Config) Client {
	return &clientImpl{
		cfg: cfg,
		httpClient: &http.Client{
			Timeout: 10 * time.Second,
		},
	}
}

func (s *clientImpl) CheckHealth(ctx context.Context) models.SupabaseHealth {
	health := models.SupabaseHealth{
		Connected: false,
		URL:       s.cfg.SupabaseURL,
		CheckedAt: time.Now().UTC(),
	}

	authURL := fmt.Sprintf("%s/auth/v1/health", s.cfg.SupabaseURL)
	req, err := http.NewRequestWithContext(ctx, "GET", authURL, nil)
	if err != nil {
		health.Error = err.Error()
		return health
	}
	req.Header.Set("apikey", s.cfg.SupabaseSecretKey)

	resp, err := s.httpClient.Do(req)
	if err != nil {
		health.Error = fmt.Sprintf("Supabase unreachable: %v", err)
		return health
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		health.AuthService = "healthy"
	} else {
		health.AuthService = fmt.Sprintf("http_%d", resp.StatusCode)
	}

	restURL := fmt.Sprintf("%s/rest/v1/", s.cfg.SupabaseURL)
	restReq, err := http.NewRequestWithContext(ctx, "GET", restURL, nil)
	if err == nil {
		restReq.Header.Set("apikey", s.cfg.SupabaseSecretKey)
		restReq.Header.Set("Authorization", fmt.Sprintf("Bearer %s", s.cfg.SupabaseSecretKey))
		if restResp, err := s.httpClient.Do(restReq); err == nil {
			defer restResp.Body.Close()
			if restResp.StatusCode == http.StatusOK {
				health.RESTService = "healthy"
			} else {
				health.RESTService = fmt.Sprintf("http_%d", restResp.StatusCode)
			}
		}
	}

	health.Connected = (resp.StatusCode == http.StatusOK)
	return health
}

func (s *clientImpl) QueryREST(ctx context.Context, method, endpoint string, body any) ([]byte, int, error) {
	url := fmt.Sprintf("%s/rest/v1/%s", s.cfg.SupabaseURL, endpoint)

	var reqBody io.Reader
	if body != nil {
		data, err := json.Marshal(body)
		if err != nil {
			return nil, 0, err
		}
		reqBody = bytes.NewBuffer(data)
	}

	req, err := http.NewRequestWithContext(ctx, method, url, reqBody)
	if err != nil {
		return nil, 0, err
	}

	req.Header.Set("apikey", s.cfg.SupabaseSecretKey)
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", s.cfg.SupabaseSecretKey))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Prefer", "return=representation")

	resp, err := s.httpClient.Do(req)
	if err != nil {
		return nil, 0, err
	}
	defer resp.Body.Close()

	respBytes, err := io.ReadAll(resp.Body)
	return respBytes, resp.StatusCode, err
}
