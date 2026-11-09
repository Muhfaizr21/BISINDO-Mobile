package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	SupabaseURL            string
	SupabasePublishableKey string
	SupabaseSecretKey      string
	SupabaseJWKSURL        string
	Port                   string
}

func LoadConfig() *Config {
	// Load .env file if it exists, otherwise fall back to environment variables
	if err := godotenv.Load(); err != nil {
		log.Println(".env file not found or could not be loaded, using environment variables")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	cfg := &Config{
		SupabaseURL:            os.Getenv("SUPABASE_URL"),
		SupabasePublishableKey: os.Getenv("SUPABASE_PUBLISHABLE_KEY"),
		SupabaseSecretKey:      os.Getenv("SUPABASE_SECRET_KEY"),
		SupabaseJWKSURL:        os.Getenv("SUPABASE_JWKS_URL"),
		Port:                   port,
	}

	if cfg.SupabaseURL == "" {
		log.Println("WARNING: SUPABASE_URL is not set!")
	}
	if cfg.SupabaseSecretKey == "" {
		log.Println("WARNING: SUPABASE_SECRET_KEY is not set!")
	}

	return cfg
}

