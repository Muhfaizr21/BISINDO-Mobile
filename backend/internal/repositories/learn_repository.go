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
		{ID: "bisindo-a", Title: "Huruf A", Description: "Kedua tangan mengepal dengan ibu jari tangan dominan tegak bersandar pada sisi jari telunjuk.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/A.jpg"},
		{ID: "bisindo-b", Title: "Huruf B", Description: "Kedua tangan terbuka tegak ke atas, saling mendekat dan sejajar di depan dada.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/B.jpg"},
		{ID: "bisindo-c", Title: "Huruf C", Description: "Tangan dominan membentuk lengkungan huruf C menghadap ke samping atau ke depan.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/C.jpg"},
		{ID: "bisindo-d", Title: "Huruf D", Description: "Jari telunjuk tangan dominan tegak lurus ke atas, jari lainnya melingkar menyentuh ibu jari.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/D.jpg"},
		{ID: "bisindo-e", Title: "Huruf E", Description: "Seluruh ujung jari tangan dominan ditekuk ke bawah merapat menyentuh ujung ibu jari.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/E.jpg"},
		{ID: "bisindo-f", Title: "Huruf F", Description: "Ujung jari telunjuk dan ibu jari bersentuhan membentuk lingkaran kecil, tiga jari lainnya tegak ke atas.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/F.jpg"},
		{ID: "bisindo-g", Title: "Huruf G", Description: "Ibu jari dan jari telunjuk direntangkan sejajar secara horizontal ke arah depan/samping.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/G.jpg"},
		{ID: "bisindo-h", Title: "Huruf H", Description: "Jari telunjuk dan jari tengah direntangkan bersamaan horizontal ke samping/depan.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/H.jpg"},
		{ID: "bisindo-i", Title: "Huruf I", Description: "Jari kelingking terangkat lurus tegak ke atas, keempat jari lainnya tertutup rapat.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/I.jpg"},
		{ID: "bisindo-j", Title: "Huruf J", Description: "Jari kelingking terangkat ke atas lalu digerakkan meliuk membentuk garis lengkung huruf J di udara.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/J.jpg"},
		{ID: "bisindo-k", Title: "Huruf K", Description: "Jari telunjuk tegak ke atas, jari tengah miring ke depan, dengan ibu jari berada di antara keduanya.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/K.jpg"},
		{ID: "bisindo-l", Title: "Huruf L", Description: "Ibu jari dan jari telunjuk direntangkan tegak membentuk sudut siku-siku 90 derajat menyerupai huruf L.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/L.jpg"},
		{ID: "bisindo-m", Title: "Huruf M", Description: "Tiga jari tangan (telunjuk, tengah, manis) ditekuk ke bawah menutupi ibu jari.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/M.jpg"},
		{ID: "bisindo-n", Title: "Huruf N", Description: "Dua jari tangan (telunjuk dan tengah) ditekuk ke bawah menutupi ibu jari.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/N.jpg"},
		{ID: "bisindo-o", Title: "Huruf O", Description: "Seluruh jari tangan dilengkungkan merata membentuk lingkaran bulat sempurna huruf O.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/O.jpg"},
		{ID: "bisindo-p", Title: "Huruf P", Description: "Bentuk gestur huruf K yang diarahkan mengarah ke bawah.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/P.jpg"},
		{ID: "bisindo-q", Title: "Huruf Q", Description: "Bentuk gestur huruf G yang diarahkan miring ke bawah.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/Q.jpg"},
		{ID: "bisindo-r", Title: "Huruf R", Description: "Jari telunjuk dan jari tengah disilangkan satu sama lain ke atas secara tegak.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/R.jpg"},
		{ID: "bisindo-s", Title: "Huruf S", Description: "Tangan mengepal erat dengan ibu jari ditekuk menyilang di depan kepalan jari-jemari.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/S.jpg"},
		{ID: "bisindo-t", Title: "Huruf T", Description: "Ibu jari diselipkan di antara jari telunjuk dan jari tengah dalam posisi mengepal.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/T.jpg"},
		{ID: "bisindo-u", Title: "Huruf U", Description: "Jari telunjuk dan jari tengah ditegakkan ke atas secara rapat sejajar.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/U.jpg"},
		{ID: "bisindo-v", Title: "Huruf V", Description: "Jari telunjuk dan jari tengah ditegakkan ke atas membentuk huruf V (victory) merenggang.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/V.jpg"},
		{ID: "bisindo-w", Title: "Huruf W", Description: "Tiga jari (telunjuk, tengah, manis) ditegakkan ke atas membentuk huruf W merenggang.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/W.jpg"},
		{ID: "bisindo-x", Title: "Huruf X", Description: "Jari telunjuk sedikit ditekuk membentuk kait atau lengkungan kait kecil.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/X.jpg"},
		{ID: "bisindo-y", Title: "Huruf Y", Description: "Ibu jari dan kelingking direntangkan keluar ke samping, tiga jari tengah dilipat ke dalam telapak.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/Y.jpg"},
		{ID: "bisindo-z", Title: "Huruf Z", Description: "Jari telunjuk ditegakkan lalu digerakkan menggores pola zigzag huruf Z di udara.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/Z.jpg"},
		{ID: "angka-1-5", Title: "Angka 1 sampai 5", Description: "Hitungan jari dasar dari satu jari terangkat hingga lima jari terbuka lebar.", Category: "Angka", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "salam-halo", Title: "Halo dan Terima Kasih", Description: "Gestur sapaan ramah dan ucapan terima kasih standar BISINDO.", Category: "Percakapan", ImageURL: "assets/images/bisindo_chart.png"},
	}
	return materials, nil
}
