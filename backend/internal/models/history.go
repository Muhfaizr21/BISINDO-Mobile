package models

import "time"

type HistoryItem struct {
	ID        string    `json:"id"`
	Text      string    `json:"text"`
	Timestamp time.Time `json:"timestamp"`
}

type CreateHistoryRequest struct {
	ID   string `json:"id,omitempty"`
	Text string `json:"text"`
}

