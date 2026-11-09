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
    ('bisindo-a', 'Huruf A', 'Kedua tangan mengepal dengan ibu jari tangan dominan tegak bersandar pada sisi jari telunjuk.', 'Abjad BISINDO'),
    ('bisindo-b', 'Huruf B', 'Kedua tangan terbuka tegak ke atas, saling mendekat dan sejajar di depan dada.', 'Abjad BISINDO'),
    ('bisindo-c', 'Huruf C', 'Tangan dominan membentuk lengkungan huruf C menghadap ke samping atau ke depan.', 'Abjad BISINDO'),
    ('bisindo-d', 'Huruf D', 'Jari telunjuk tangan dominan tegak lurus ke atas, jari lainnya melingkar menyentuh ibu jari.', 'Abjad BISINDO'),
    ('bisindo-e', 'Huruf E', 'Seluruh ujung jari tangan dominan ditekuk ke bawah merapat menyentuh ujung ibu jari.', 'Abjad BISINDO'),
    ('bisindo-f', 'Huruf F', 'Ujung jari telunjuk dan ibu jari bersentuhan membentuk lingkaran kecil, tiga jari lainnya tegak ke atas.', 'Abjad BISINDO'),
    ('bisindo-g', 'Huruf G', 'Ibu jari dan jari telunjuk direntangkan sejajar secara horizontal ke arah depan/samping.', 'Abjad BISINDO'),
    ('bisindo-h', 'Huruf H', 'Jari telunjuk dan jari tengah direntangkan bersamaan horizontal ke samping/depan.', 'Abjad BISINDO'),
    ('bisindo-i', 'Huruf I', 'Jari kelingking terangkat lurus tegak ke atas, keempat jari lainnya tertutup rapat.', 'Abjad BISINDO'),
    ('bisindo-j', 'Huruf J', 'Jari kelingking terangkat ke atas lalu digerakkan meliuk membentuk garis lengkung huruf J di udara.', 'Abjad BISINDO'),
    ('bisindo-k', 'Huruf K', 'Jari telunjuk tegak ke atas, jari tengah miring ke depan, dengan ibu jari berada di antara keduanya.', 'Abjad BISINDO'),
    ('bisindo-l', 'Huruf L', 'Ibu jari dan jari telunjuk direntangkan tegak membentuk sudut siku-siku 90 derajat menyerupai huruf L.', 'Abjad BISINDO'),
    ('bisindo-m', 'Huruf M', 'Tiga jari tangan (telunjuk, tengah, manis) ditekuk ke bawah menutupi ibu jari.', 'Abjad BISINDO'),
    ('bisindo-n', 'Huruf N', 'Dua jari tangan (telunjuk dan tengah) ditekuk ke bawah menutupi ibu jari.', 'Abjad BISINDO'),
    ('bisindo-o', 'Huruf O', 'Seluruh jari tangan dilengkungkan merata membentuk lingkaran bulat sempurna huruf O.', 'Abjad BISINDO'),
    ('bisindo-p', 'Huruf P', 'Bentuk gestur huruf K yang diarahkan mengarah ke bawah.', 'Abjad BISINDO'),
    ('bisindo-q', 'Huruf Q', 'Bentuk gestur huruf G yang diarahkan miring ke bawah.', 'Abjad BISINDO'),
    ('bisindo-r', 'Huruf R', 'Jari telunjuk dan jari tengah disilangkan satu sama lain ke atas secara tegak.', 'Abjad BISINDO'),
    ('bisindo-s', 'Huruf S', 'Tangan mengepal erat dengan ibu jari ditekuk menyilang di depan kepalan jari-jemari.', 'Abjad BISINDO'),
    ('bisindo-t', 'Huruf T', 'Ibu jari diselipkan di antara jari telunjuk dan jari tengah dalam posisi mengepal.', 'Abjad BISINDO'),
    ('bisindo-u', 'Huruf U', 'Jari telunjuk dan jari tengah ditegakkan ke atas secara rapat sejajar.', 'Abjad BISINDO'),
    ('bisindo-v', 'Huruf V', 'Jari telunjuk dan jari tengah ditegakkan ke atas membentuk huruf V (victory) merenggang.', 'Abjad BISINDO'),
    ('bisindo-w', 'Huruf W', 'Tiga jari (telunjuk, tengah, manis) ditegakkan ke atas membentuk huruf W merenggang.', 'Abjad BISINDO'),
    ('bisindo-x', 'Huruf X', 'Jari telunjuk sedikit ditekuk membentuk kait atau lengkungan kait kecil.', 'Abjad BISINDO'),
    ('bisindo-y', 'Huruf Y', 'Ibu jari dan kelingking direntangkan keluar ke samping, tiga jari tengah dilipat ke dalam telapak.', 'Abjad BISINDO'),
    ('bisindo-z', 'Huruf Z', 'Jari telunjuk ditegakkan lalu digerakkan menggores pola zigzag huruf Z di udara.', 'Abjad BISINDO'),
    ('angka-1-5', 'Angka 1 sampai 5', 'Hitungan jari dasar dari satu jari terangkat hingga lima jari terbuka lebar.', 'Angka'),
    ('salam-halo', 'Halo dan Terima Kasih', 'Gestur sapaan ramah dan ucapan terima kasih standar BISINDO.', 'Percakapan')
on conflict (id) do nothing;
