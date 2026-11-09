package models

type LearnItem struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Category    string `json:"category"`
	ImageURL    string `json:"image_url,omitempty"`
}
