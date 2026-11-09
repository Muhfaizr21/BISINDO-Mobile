package services

import (
	"context"

	"backend/internal/models"
	"backend/internal/repositories"
)

type LearnService interface {
	FetchMaterials(ctx context.Context) ([]models.LearnItem, error)
}

type learnServiceImpl struct {
	repo repositories.LearnRepository
}

func NewLearnService(repo repositories.LearnRepository) LearnService {
	return &learnServiceImpl{repo: repo}
}

func (s *learnServiceImpl) FetchMaterials(ctx context.Context) ([]models.LearnItem, error) {
	return s.repo.GetMaterials(ctx)
}

