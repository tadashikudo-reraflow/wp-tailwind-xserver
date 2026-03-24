<?php
/**
 * Title: News
 * Slug: wpts/news
 * Categories: wpts
 */
$args = [
	'post_type'      => 'post',
	'posts_per_page' => 5,
	'post_status'    => 'publish',
	'orderby'        => 'date',
	'order'          => 'DESC',
];
$news = new WP_Query( $args );
?>
<section class="rr-section rr-section--white" id="news">
	<div class="rr-section__inner">
		<div class="rr-section__header">
			<p class="rr-label">news</p>
			<h2 class="rr-section__title">News</h2>
		</div>

		<div class="rr-news-list">
			<?php if ( $news->have_posts() ) : ?>
				<?php while ( $news->have_posts() ) : $news->the_post(); ?>
					<a href="<?php the_permalink(); ?>" class="rr-news-item">
						<span class="rr-news-item__date"><?php echo get_the_date( 'Y.m.d' ); ?></span>
						<?php
						$cats = get_the_category();
						if ( $cats ) :
						?>
							<span class="rr-news-item__tag"><?php echo esc_html( $cats[0]->name ); ?></span>
						<?php endif; ?>
						<span class="rr-news-item__title"><?php the_title(); ?></span>
					</a>
				<?php endwhile; wp_reset_postdata(); ?>
			<?php else : ?>
				<p class="rr-news-empty">No posts yet.</p>
			<?php endif; ?>
		</div>

		<div class="rr-news-more">
			<a href="<?php echo esc_url( get_post_type_archive_link( 'post' ) ); ?>" class="rr-link rr-link--more">View all news →</a>
		</div>
	</div>
</section>
