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

-- Initial Seed Data for BISINDO Learning Materials
insert into public.learn_materials (id, title, description, category)
values
    ('huruf-a', 'Huruf A', 'Kepalkan seluruh jari dengan ibu jari tegak di samping jari telunjuk.', 'Abjad'),
    ('huruf-b', 'Huruf B', 'Buka keempat jari ke atas secara rapat, tekuk ibu jari di depan telapak.', 'Abjad'),
    ('huruf-c', 'Huruf C', 'Lengkungkan seluruh jari membentuk huruf C menghadap ke samping.', 'Abjad'),
    ('huruf-d', 'Huruf D', 'Tegakkan jari telunjuk ke atas, jari lainnya menyentuh ibu jari membentuk lingkaran.', 'Abjad'),
    ('huruf-e', 'Huruf E', 'Tekuk semua jari ke bawah menyentuh ujung ibu jari.', 'Abjad'),
    ('angka-1', 'Angka 1', 'Angkat jari telunjuk lurus ke atas dengan jari lainnya mengepal.', 'Angka'),
    ('angka-2', 'Angka 2', 'Bentuk huruf V dengan jari telunjuk dan tengah terangkat tegak.', 'Angka'),
    ('angka-3', 'Angka 3', 'Angkat ibu jari, telunjuk, dan jari tengah ke atas.', 'Angka'),
    ('angka-4', 'Angka 4', 'Buka empat jari (telunjuk sampai kelingking) dengan ibu jari dilipat ke telapak.', 'Angka'),
    ('angka-5', 'Angka 5', 'Buka seluruh lima jari tangan melebar menghadap ke depan.', 'Angka'),
    ('salam-halo', 'Halo', 'Lambaikan tangan terbuka ke arah depan setinggi bahu.', 'Frasa'),
    ('salam-terima-kasih', 'Terima Kasih', 'Sentuhkan ujung jari ke dagu atau bibir lalu gerakkan tangan ke depan.', 'Frasa'),
    ('salam-sama-sama', 'Sama-sama', 'Buka kedua telapak tangan menghadap ke atas sedikit digerakkan ke depan.', 'Frasa')
on conflict (id) do nothing;
