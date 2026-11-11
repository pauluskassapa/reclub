begin;

create table if not exists public.feed_posts (
  id uuid primary key default gen_random_uuid(),
  club text not null,
  initials text not null,
  category text not null,
  title text not null,
  message text not null,
  image_path text not null,
  likes integer not null default 0 check (likes >= 0),
  is_published boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.feed_posts enable row level security;

revoke all on public.feed_posts from anon, authenticated;
grant select on public.feed_posts to anon, authenticated;

drop policy if exists feed_read_published on public.feed_posts;
create policy feed_read_published
on public.feed_posts for select
to anon, authenticated
using (is_published = true);

insert into public.feed_posts
  (id, club, initials, category, title, message, image_path, likes)
values
  ('047fc689-15d0-47b0-8d9b-2ae209686001',
   'Jakarta Futsal Club', 'JF', 'Futsal', 'Main bareng akhir pekan',
   'Latihan lebih seru kalau bareng teman! Yuk, siapkan sepatu dan ajak tim kamu untuk main futsal akhir pekan ini.',
   'assets/images/futsal.jpg', 24),
  ('047fc689-15d0-47b0-8d9b-2ae209686002',
   'Badminton Weekend', 'BW', 'Badminton', 'Pemula juga boleh ikut',
   'Tidak perlu jago dulu untuk mulai bermain. Di komunitas ini kita latihan, belajar teknik dasar, dan saling menyemangati.',
   'assets/images/badminton.jpg', 18),
  ('047fc689-15d0-47b0-8d9b-2ae209686003',
   'Jakarta Morning Runners', 'JR', 'Lari', 'Mulai dari langkah kecil',
   'Lari santai, pemanasan dulu, dan jangan lupa bawa air minum. Nikmati prosesnya bersama teman-teman komunitas.',
   'assets/images/running.jpg', 31)
on conflict (id) do nothing;

commit;
