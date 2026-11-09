package repositories

import (
	"context"

	"backend/internal/models"
)

type LearnRepository interface {
	GetMaterials(ctx context.Context) ([]models.LearnItem, error)
}

type DefaultLearnRepository struct{}

func NewDefaultLearnRepository() *DefaultLearnRepository {
	return &DefaultLearnRepository{}
}

func (r *DefaultLearnRepository) GetMaterials(ctx context.Context) ([]models.LearnItem, error) {
	materials := []models.LearnItem{
		{
			ID:          "1",
			Title:       "Alfabet BISINDO A - Z",
			Description: "Panduan visual gestur alfabet BISINDO dengan dua tangan",
			Category:    "Dasar",
		},
		{
			ID:          "2",
			Title:       "Alfabet SIBI A - Z",
			Description: "Panduan visual gestur alfabet SIBI dengan satu tangan",
			Category:    "Dasar",
		},
		{
			ID:          "3",
			Title:       "Angka 0 - 10",
			Description: "Mengenal angka dan hitungan dalam bahasa isyarat",
			Category:    "Angka",
		},
		{
			ID:          "4",
			Title:       "Kata Sapaan dan Ucapan Sehari-hari",
			Description: "Halo, Selamat Pagi, Terima Kasih, Maaf, Tolong",
			Category:    "Percakapan",
		},
	}
	return materials, nil
}

