-- Expense Tracker - Supabase schema
-- Run this once in: Supabase Dashboard > SQL Editor > New query > Run

create table if not exists public.expenses (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title       text not null,
  amount      numeric(10, 2) not null check (amount > 0),
  category    text not null,
  date        date not null default current_date,
  created_at  timestamptz not null default now()
);

-- Allow logged-in users to use the table through the API
grant select, insert, update, delete on public.expenses to authenticated;

-- Row Level Security: every user can only see and change their own expenses
alter table public.expenses enable row level security;

create policy "Users can read their own expenses"
  on public.expenses for select
  using (auth.uid() = user_id);

create policy "Users can add their own expenses"
  on public.expenses for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own expenses"
  on public.expenses for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete their own expenses"
  on public.expenses for delete
  using (auth.uid() = user_id);
