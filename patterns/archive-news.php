<?php
/**
 * Title: Archive News
 * Slug: wpts/archive-news
 * Categories: reraflow
 */
?>
<main class="rr-single">
	<div class="rr-single__inner">
		<div class="rr-section__header" style="text-align:left; margin-bottom:40px;">
			<p class="rr-label">news</p>
			<h1 class="rr-section__title" style="text-align:left;">News</h1>
		</div>

		<div class="rr-news-list">
			<?php if ( have_posts() ) : ?>
				<?php while ( have_posts() ) : the_post(); ?>
					<a href="<?php the_permalink(); ?>" class="rr-news-item">
						<span class="rr-news-item__date"><?php echo get_the_date( 'Y.m.d' ); ?></span>
						<?php $cats = get_the_category(); if ( $cats ) : ?>
							<span class="rr-news-item__tag"><?php echo esc_html( $cats[0]->name ); ?></span>
						<?php endif; ?>
						<span class="rr-news-item__title"><?php the_title(); ?></span>
					</a>
				<?php endwhile; ?>

				<div class="rr-news-pagination">
					<?php the_posts_pagination( [ 'mid_size' => 2 ] ); ?>
				</div>
			<?php else : ?>
				<p class="rr-news-empty">No posts yet.</p>
			<?php endif; ?>
		</div>
	</div>
</main>
