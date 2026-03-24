<?php
/**
 * Title: Single Post
 * Slug: wpts/single-post
 * Categories: wpts
 */
if ( ! have_posts() ) return;
the_post();
$cats = get_the_category();
?>
<main class="rr-single">
	<div class="rr-single__inner">

		<div class="rr-single__meta">
			<span class="rr-single__date"><?php echo get_the_date( 'Y.m.d' ); ?></span>
			<?php if ( $cats ) : ?>
				<span class="rr-news-item__tag"><?php echo esc_html( $cats[0]->name ); ?></span>
			<?php endif; ?>
		</div>

		<h1 class="rr-single__title"><?php the_title(); ?></h1>

		<div class="rr-single__content">
			<?php the_content(); ?>
		</div>

		<div class="rr-single__back">
			<a href="<?php echo esc_url( home_url( '/news' ) ); ?>" class="rr-link">← Back to News</a>
		</div>

	</div>
</main>
