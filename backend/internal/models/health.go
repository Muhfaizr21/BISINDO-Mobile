package models

import "time"

type SupabaseHealth struct {
	Connected   bool      `json:"connected"`
	URL         string    `json:"url"`
	AuthService string    `json:"auth_service"`
	RESTService string    `json:"rest_service"`
	CheckedAt   time.Time `json:"checked_at"`
	Error       string    `json:"error,omitempty"`
}

type SystemHealth struct {
	Status    string         `json:"status"`
	Service   string         `json:"service"`
	Runtime   string         `json:"runtime"`
	Timestamp time.Time      `json:"timestamp"`
	Supabase  SupabaseHealth `json:"supabase"`
}

