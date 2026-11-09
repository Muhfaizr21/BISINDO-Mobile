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
		{ID: "bisindo-a", Title: "Huruf A", Description: "Kedua jari telunjuk dipertemukan di puncak membentuk sudut lancip dan kedua ibu jari bertemu mendatar di bawah membentuk segitiga huruf A.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/A.jpg"},
		{ID: "bisindo-b", Title: "Huruf B", Description: "Jari telunjuk satu tangan tegak lurus sebagai tiang, ditempel oleh tiga jari mendatar dari tangan lainnya membentuk perut huruf B.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/B.jpg"},
		{ID: "bisindo-c", Title: "Huruf C", Description: "Satu tangan melengkungkan jari-jari dan ibu jari membentuk busur terbuka menyerupai huruf C.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/C.jpg"},
		{ID: "bisindo-d", Title: "Huruf D", Description: "Jari telunjuk satu tangan tegak lurus, sementara telunjuk dan ibu jari tangan lainnya membentuk lengkungan huruf D yang menempel pada tiang telunjuk.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/D.jpg"},
		{ID: "bisindo-e", Title: "Huruf E", Description: "Satu tangan merentangkan tiga jari (telunjuk, tengah, manis) secara mendatar ke samping menyerupai tiga garis huruf E, sementara kelingking dan ibu jari ditekuk.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/E.jpg"},
		{ID: "bisindo-f", Title: "Huruf F", Description: "Jari telunjuk satu tangan tegak lurus, ditempel secara mendatar oleh jari telunjuk dan jari tengah tangan lainnya di bagian atas membentuk huruf F.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/F.jpg"},
		{ID: "bisindo-g", Title: "Huruf G", Description: "Kedua kepalan tangan ditumpuk secara vertikal di depan dada membentuk lekukan huruf G.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/G.jpg"},
		{ID: "bisindo-h", Title: "Huruf H", Description: "Kedua jari telunjuk ditegakkan sejajar dengan ibu jari melintang di tengah menghubungkan keduanya menyerupai huruf H.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/H.jpg"},
		{ID: "bisindo-i", Title: "Huruf I", Description: "Satu tangan mengangkat jari kelingking tegak lurus ke atas, sementara keempat jari lainnya mengepal rapat.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/I.jpg"},
		{ID: "bisindo-j", Title: "Huruf J", Description: "Satu tangan mengangkat jari kelingking dan memiringkannya membentuk ayunan lengkung huruf J.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/J.jpg"},
		{ID: "bisindo-k", Title: "Huruf K", Description: "Jari telunjuk satu tangan tegak lurus, ditempel pada bagian tengah oleh jari telunjuk dan tengah tangan lainnya yang membentuk sudut huruf K.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/K.jpg"},
		{ID: "bisindo-l", Title: "Huruf L", Description: "Satu tangan merentangkan jari telunjuk tegak ke atas dan ibu jari mendatar ke samping membentuk sudut siku-siku 90 derajat huruf L.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/L.jpg"},
		{ID: "bisindo-m", Title: "Huruf M", Description: "Satu telapak tangan terbuka menjadi tumpuan, sementara tiga jari (telunjuk, tengah, manis) tangan lainnya ditempelkan di atas telapak membentuk tiga kaki huruf M.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/M.jpg"},
		{ID: "bisindo-n", Title: "Huruf N", Description: "Satu telapak tangan terbuka menjadi tumpuan, sementara dua jari (telunjuk dan tengah) tangan lainnya ditempelkan di atas telapak membentuk dua kaki huruf N.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/N.jpg"},
		{ID: "bisindo-o", Title: "Huruf O", Description: "Satu tangan mempertemukan ujung jari telunjuk dan ibu jari membentuk lingkaran bulat sempurna menyerupai huruf O.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/O.jpg"},
		{ID: "bisindo-p", Title: "Huruf P", Description: "Jari telunjuk satu tangan tegak lurus, sementara telunjuk dan ibu jari tangan lainnya membentuk lengkungan setengah lingkaran di bagian ujung atas tiang telunjuk menyerupai huruf P.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/P.jpg"},
		{ID: "bisindo-q", Title: "Huruf Q", Description: "Satu tangan membentuk lingkaran bulat dengan ibu jari dan telunjuk, sementara jari telunjuk tangan lainnya menyentuh bagian tengah lingkaran membentuk ekor huruf Q.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/Q.jpg"},
		{ID: "bisindo-r", Title: "Huruf R", Description: "Satu tangan menegakkan jari telunjuk dan jari tengah sambil menyilangkannya rapat ke atas.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/R.jpg"},
		{ID: "bisindo-s", Title: "Huruf S", Description: "Kedua tangan membentuk lengkungan huruf C yang saling bertumpuk berlawanan arah membentuk alur berliku huruf S.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/S.jpg"},
		{ID: "bisindo-t", Title: "Huruf T", Description: "Jari telunjuk satu tangan ditegakkan vertikal, lalu jari telunjuk tangan lainnya diletakkan mendatar di atas ujungnya membentuk palang huruf T.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/T.jpg"},
		{ID: "bisindo-u", Title: "Huruf U", Description: "Satu tangan menegakkan jari telunjuk dan jari kelingking ke atas sementara jari tengah dan manis dilipat membentuk cekungan huruf U.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/U.jpg"},
		{ID: "bisindo-v", Title: "Huruf V", Description: "Satu tangan menegakkan jari telunjuk dan jari tengah membentuk sudut merenggang menyerupai huruf V.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/V.jpg"},
		{ID: "bisindo-w", Title: "Huruf W", Description: "Kedua tangan membuka ibu jari dan telunjuk lalu mempertemukan ujung ibu jari di tengah sehingga membentuk empat puncak sudut huruf W.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/W.jpg"},
		{ID: "bisindo-x", Title: "Huruf X", Description: "Kedua jari telunjuk disilangkan satu sama lain di depan dada membentuk tanda silang huruf X.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/X.jpg"},
		{ID: "bisindo-y", Title: "Huruf Y", Description: "Satu tangan membuka jari telunjuk dan tengah membentuk V di atas, sementara jari telunjuk tangan lainnya menempel di bawah pangkalnya sebagai tangkai huruf Y.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/Y.jpg"},
		{ID: "bisindo-z", Title: "Huruf Z", Description: "Satu tangan dengan jari-jari rapat ditekuk mendatar pada pergelangan dan siku membentuk sudut zig-zag huruf Z.", Category: "Abjad BISINDO", ImageURL: "assets/images/bisindo/Z.jpg"},
		{ID: "bisindo-num-0", Title: "Angka 0", Description: "Ibu jari dan jari telunjuk dipertemukan membentuk lingkaran menyerupai angka 0 / huruf O, jari-jari lainnya melipat membulat.", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-1", Title: "Angka 1", Description: "Hanya jari telunjuk yang diangkat mengarah ke atas tegak lurus, sementara jari-jari lainnya mengepal rapat.", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-2", Title: "Angka 2", Description: "Jari telunjuk dan jari tengah diangkat ke atas secara sejajar, sedangkan jari manis dan kelingking mengepal rapat.", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-3", Title: "Angka 3", Description: "Tiga jari (telunjuk, tengah, manis) diangkat ke atas secara tegak, ibu jari dan kelingking melipat ke dalam telapak tangan.", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-4", Title: "Angka 4", Description: "Empat jari diangkat ke atas (telunjuk, tengah, manis, kelingking), sedangkan ibu jari dilipat di depan telapak tangan.", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-5", Title: "Angka 5", Description: "Telapak tangan dibuka lebar menghadap ke depan dengan kelima jari (ibu jari sampai kelingking) direntangkan terbuka.", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-6", Title: "Angka 6", Description: "Dua tangan: satu tangan membuka telapak tangan (5), ditambah satu jari dari tangan lainnya (5 + 1). (Alternatif 1 tangan: ibu jari dan kelingking direntangkan - pose shaka).", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-7", Title: "Angka 7", Description: "Dua tangan: satu tangan membuka telapak tangan (5), ditambah dua jari dari tangan lainnya (5 + 2). (Alternatif 1 tangan: ibu jari dan telunjuk membentuk sudut L).", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-8", Title: "Angka 8", Description: "Dua tangan: satu tangan membuka telapak tangan (5), ditambah tiga jari dari tangan lainnya (5 + 3). (Alternatif 1 tangan: jari tengah menyentuh ibu jari dengan jari lain tegak).", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "bisindo-num-9", Title: "Angka 9", Description: "Dua tangan: satu tangan membuka telapak tangan (5), ditambah empat jari dari tangan lainnya (5 + 4). (Alternatif 1 tangan: telunjuk dan ibu jari bertemu bulat dengan 3 jari lain tegak).", Category: "Angka BISINDO", ImageURL: "assets/images/bisindo_chart.png"},
		{ID: "salam-halo", Title: "Halo dan Terima Kasih", Description: "Gestur sapaan ramah dan ucapan terima kasih standar BISINDO.", Category: "Percakapan", ImageURL: "assets/images/bisindo_chart.png"},
	}
	return materials, nil
}
