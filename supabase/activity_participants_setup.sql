begin;

create table if not exists public.activity_participants (
  id uuid primary key default gen_random_uuid(),
  activity_title text not null,
  category text not null,
  participant_name text not null,
  position text not null default 'Peserta',
  is_host boolean not null default false,
  created_at timestamptz not null default now(),
  constraint activity_participants_unique_member unique (activity_title, participant_name)
);

create index if not exists idx_activity_participants_title
  on public.activity_participants (activity_title);

alter table public.activity_participants enable row level security;

revoke all on public.activity_participants from anon, authenticated;
grant select, insert, update, delete on public.activity_participants to anon, authenticated;

drop policy if exists activity_participants_select_all on public.activity_participants;
create policy activity_participants_select_all
on public.activity_participants for select
to anon, authenticated
using (true);

drop policy if exists activity_participants_insert_all on public.activity_participants;
create policy activity_participants_insert_all
on public.activity_participants for insert
to anon, authenticated
with check (
  char_length(trim(activity_title)) > 0
  and char_length(trim(participant_name)) > 0
);

drop policy if exists activity_participants_update_all on public.activity_participants;
create policy activity_participants_update_all
on public.activity_participants for update
to anon, authenticated
using (true)
with check (
  char_length(trim(activity_title)) > 0
  and char_length(trim(participant_name)) > 0
);

drop policy if exists activity_participants_delete_all on public.activity_participants;
create policy activity_participants_delete_all
on public.activity_participants for delete
to anon, authenticated
using (true);

commit;
