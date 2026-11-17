begin;

grant insert (club, initials, category, title, message, image_path, is_published)
on public.feed_posts to anon, authenticated;

drop policy if exists feed_submit_pending on public.feed_posts;
create policy feed_submit_pending on public.feed_posts
for insert to anon, authenticated
with check (
  is_published = false
  and likes = 0
  and char_length(btrim(club)) between 1 and 80
  and char_length(initials) between 1 and 8
  and char_length(btrim(title)) between 1 and 120
  and char_length(btrim(message)) between 1 and 2000
  and category in ('Futsal','Badminton','Basket','Lari','Voli','Tenis','Sepeda','Renang','Yoga','Pingpong')
  and image_path in (
    'assets/images/futsal.jpg','assets/images/badminton.jpg',
    'assets/images/basket.jpg','assets/images/running.jpg',
    'assets/images/volleyball.jpg','assets/images/tennis.jpg',
    'assets/images/cycling.jpg','assets/images/swimming.jpg',
    'assets/images/yoga.jpg','assets/images/pingpong.jpg'
  )
);

commit;
