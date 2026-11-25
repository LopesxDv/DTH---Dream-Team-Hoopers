-- Dream Team Hoopers: tabela das salas online
create table if not exists public.rooms (
  code text primary key,
  host uuid not null,
  host_name text not null,
  guest uuid,
  guest_name text,
  state jsonb,
  act jsonb,
  closed boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.rooms enable row level security;

create policy "ver salas" on public.rooms for select to authenticated
  using (host = auth.uid() or guest = auth.uid() or guest is null);

create policy "criar sala" on public.rooms for insert to authenticated
  with check (host = auth.uid());

create policy "atualizar sala" on public.rooms for update to authenticated
  using (host = auth.uid() or guest = auth.uid() or guest is null)
  with check (host = auth.uid() or guest = auth.uid());

create policy "apagar sala" on public.rooms for delete to authenticated
  using (host = auth.uid());

alter publication supabase_realtime add table public.rooms;
