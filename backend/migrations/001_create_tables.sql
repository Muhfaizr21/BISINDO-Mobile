-- BISINDO-Mobile Database Schema Migration
-- 001_create_tables.sql

-- Enable UUID extension if not already enabled
create extension if not exists "uuid-ossp";

-- 1. History Table
create table if not exists public.history (
    id text primary key,
    text text not null,
    timestamp timestamptz not null default now()
);

-- Index for chronological sorting
create index if not exists idx_history_timestamp on public.history (timestamp desc);

-- 2. Learn Materials Table
create table if not exists public.learn_materials (
    id text primary key,
    title text not null,
    description text not null,
    category text not null,
    created_at timestamptz not null default now()
);

-- Index for category filtering
create index if not exists idx_learn_materials_category on public.learn_materials (category);

-- 3. Row Level Security (RLS)
alter table public.history enable row level security;
alter table public.learn_materials enable row level security;

-- Policies for history: allow public read and insert/delete for mobile clients with anon/service key
create policy "Allow read access to all" on public.history
    for select using (true);

create policy "Allow insert access to all" on public.history
    for insert with check (true);

create policy "Allow delete access to all" on public.history
    for delete using (true);

-- Policies for learn_materials: read-only for public, modifications restricted
create policy "Allow read access to learn materials" on public.learn_materials
    for select using (true);

-- Initial Seed Data for BISINDO Learning Materials (26 Alphabet Classes + Numbers + Greetings)
insert into public.learn_materials (id, title, description, category)
values
    ('bisindo-a', 'Huruf A', 'Kedua jari telunjuk dipertemukan di puncak membentuk sudut lancip dan kedua ibu jari bertemu mendatar di bawah membentuk segitiga huruf A.', 'Abjad BISINDO'),
    ('bisindo-b', 'Huruf B', 'Jari telunjuk satu tangan tegak lurus sebagai tiang, ditempel oleh tiga jari mendatar dari tangan lainnya membentuk perut huruf B.', 'Abjad BISINDO'),
    ('bisindo-c', 'Huruf C', 'Satu tangan melengkungkan jari-jari dan ibu jari membentuk busur terbuka menyerupai huruf C.', 'Abjad BISINDO'),
    ('bisindo-d', 'Huruf D', 'Jari telunjuk satu tangan tegak lurus, sementara telunjuk dan ibu jari tangan lainnya membentuk lengkungan huruf D yang menempel pada tiang telunjuk.', 'Abjad BISINDO'),
    ('bisindo-e', 'Huruf E', 'Satu tangan merentangkan tiga jari (telunjuk, tengah, manis) secara mendatar ke samping menyerupai tiga garis huruf E, sementara kelingking dan ibu jari ditekuk.', 'Abjad BISINDO'),
    ('bisindo-f', 'Huruf F', 'Jari telunjuk satu tangan tegak lurus, ditempel secara mendatar oleh jari telunjuk dan jari tengah tangan lainnya di bagian atas membentuk huruf F.', 'Abjad BISINDO'),
    ('bisindo-g', 'Huruf G', 'Kedua kepalan tangan ditumpuk secara vertikal di depan dada membentuk lekukan huruf G.', 'Abjad BISINDO'),
    ('bisindo-h', 'Huruf H', 'Kedua jari telunjuk ditegakkan sejajar dengan ibu jari melintang di tengah menghubungkan keduanya menyerupai huruf H.', 'Abjad BISINDO'),
    ('bisindo-i', 'Huruf I', 'Satu tangan mengangkat jari kelingking tegak lurus ke atas, sementara keempat jari lainnya mengepal rapat.', 'Abjad BISINDO'),
    ('bisindo-j', 'Huruf J', 'Satu tangan mengangkat jari kelingking dan memiringkannya membentuk ayunan lengkung huruf J.', 'Abjad BISINDO'),
    ('bisindo-k', 'Huruf K', 'Jari telunjuk satu tangan tegak lurus, ditempel pada bagian tengah oleh jari telunjuk dan tengah tangan lainnya yang membentuk sudut huruf K.', 'Abjad BISINDO'),
    ('bisindo-l', 'Huruf L', 'Satu tangan merentangkan jari telunjuk tegak ke atas dan ibu jari mendatar ke samping membentuk sudut siku-siku 90 derajat huruf L.', 'Abjad BISINDO'),
    ('bisindo-m', 'Huruf M', 'Satu telapak tangan terbuka menjadi tumpuan, sementara tiga jari (telunjuk, tengah, manis) tangan lainnya ditempelkan di atas telapak membentuk tiga kaki huruf M.', 'Abjad BISINDO'),
    ('bisindo-n', 'Huruf N', 'Satu telapak tangan terbuka menjadi tumpuan, sementara dua jari (telunjuk dan tengah) tangan lainnya ditempelkan di atas telapak membentuk dua kaki huruf N.', 'Abjad BISINDO'),
    ('bisindo-o', 'Huruf O', 'Satu tangan mempertemukan ujung jari telunjuk dan ibu jari membentuk lingkaran bulat sempurna menyerupai huruf O.', 'Abjad BISINDO'),
    ('bisindo-p', 'Huruf P', 'Jari telunjuk satu tangan tegak lurus, sementara telunjuk dan ibu jari tangan lainnya membentuk lengkungan setengah lingkaran di bagian ujung atas tiang telunjuk menyerupai huruf P.', 'Abjad BISINDO'),
    ('bisindo-q', 'Huruf Q', 'Satu tangan membentuk lingkaran bulat dengan ibu jari dan telunjuk, sementara jari telunjuk tangan lainnya menyentuh bagian tengah lingkaran membentuk ekor huruf Q.', 'Abjad BISINDO'),
    ('bisindo-r', 'Huruf R', 'Satu tangan menegakkan jari telunjuk dan jari tengah sambil menyilangkannya rapat ke atas.', 'Abjad BISINDO'),
    ('bisindo-s', 'Huruf S', 'Kedua tangan membentuk lengkungan huruf C yang saling bertumpuk berlawanan arah membentuk alur berliku huruf S.', 'Abjad BISINDO'),
    ('bisindo-t', 'Huruf T', 'Jari telunjuk satu tangan ditegakkan vertikal, lalu jari telunjuk tangan lainnya diletakkan mendatar di atas ujungnya membentuk palang huruf T.', 'Abjad BISINDO'),
    ('bisindo-u', 'Huruf U', 'Satu tangan menegakkan jari telunjuk dan jari kelingking ke atas sementara jari tengah dan manis dilipat membentuk cekungan huruf U.', 'Abjad BISINDO'),
    ('bisindo-v', 'Huruf V', 'Satu tangan menegakkan jari telunjuk dan jari tengah membentuk sudut merenggang menyerupai huruf V.', 'Abjad BISINDO'),
    ('bisindo-w', 'Huruf W', 'Kedua tangan membuka ibu jari dan telunjuk lalu mempertemukan ujung ibu jari di tengah sehingga membentuk empat puncak sudut huruf W.', 'Abjad BISINDO'),
    ('bisindo-x', 'Huruf X', 'Kedua jari telunjuk disilangkan satu sama lain di depan dada membentuk tanda silang huruf X.', 'Abjad BISINDO'),
    ('bisindo-y', 'Huruf Y', 'Satu tangan membuka jari telunjuk dan tengah membentuk V di atas, sementara jari telunjuk tangan lainnya menempel di bawah pangkalnya sebagai tangkai huruf Y.', 'Abjad BISINDO'),
    ('bisindo-z', 'Huruf Z', 'Satu tangan dengan jari-jari rapat ditekuk mendatar pada pergelangan dan siku membentuk sudut zig-zag huruf Z.', 'Abjad BISINDO'),
    ('angka-1-5', 'Angka 1 sampai 5', 'Hitungan jari dasar dari satu jari terangkat hingga lima jari terbuka lebar.', 'Angka'),
    ('salam-halo', 'Halo dan Terima Kasih', 'Gestur sapaan ramah dan ucapan terima kasih standar BISINDO.', 'Percakapan')
on conflict (id) do nothing;
