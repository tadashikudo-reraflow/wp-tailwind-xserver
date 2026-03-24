<?php
/**
 * WP Tailwind Xserver Theme Functions
 *
 * Replace SITE_NAME, SITE_TAGLINE, SITE_DESCRIPTION, TWITTER_ID
 * with your own values before deploying.
 */

if ( ! defined( 'ABSPATH' ) ) exit;

define( 'WPTS_SITE_NAME',        'Your Site Name' );
define( 'WPTS_SITE_TAGLINE',     'Your tagline here' );
define( 'WPTS_SITE_DESCRIPTION', 'Short description of your site for SEO and OGP.' );
define( 'WPTS_TWITTER_ID',       '@yourtwitterhandle' );

/**
 * Enqueue styles
 */
function wpts_enqueue_styles() {
	// Tailwind CSS
	wp_enqueue_style(
		'wpts-tailwind',
		get_template_directory_uri() . '/assets/css/tailwind.css',
		[],
		filemtime( get_template_directory() . '/assets/css/tailwind.css' )
	);

	// Google Fonts — replace with your preferred fonts if needed
	wp_enqueue_style(
		'wpts-fonts',
		'https://fonts.googleapis.com/css2?family=Inter:wght@300;400&family=Noto+Sans+JP:wght@400;600;700;900&display=swap',
		[],
		null
	);

	// Remove WP block CSS (pure HTML patterns — no WP blocks used in frontend)
	wp_dequeue_style( 'wp-block-library' );
	wp_dequeue_style( 'wp-block-library-theme' );
	wp_dequeue_style( 'global-styles' );
	wp_dequeue_style( 'classic-theme-styles' );
}
add_action( 'wp_enqueue_scripts', 'wpts_enqueue_styles', 100 );

/**
 * Register block pattern category
 */
function wpts_register_pattern_categories() {
	register_block_pattern_category( 'wpts', [
		'label' => 'WP Tailwind Xserver',
	] );
}
add_action( 'init', 'wpts_register_pattern_categories' );

/**
 * Theme setup
 */
function wpts_setup() {
	add_theme_support( 'title-tag' );
	add_theme_support( 'post-thumbnails' );
	add_theme_support( 'responsive-embeds' );
}
add_action( 'after_setup_theme', 'wpts_setup' );

/**
 * OGP / SNS meta tags
 */
function wpts_ogp_meta() {
	$site_name  = WPTS_SITE_NAME;
	$site_url   = home_url();
	$ogp_image  = get_template_directory_uri() . '/assets/images/ogp.png';
	$twitter_id = WPTS_TWITTER_ID;

	if ( is_singular() ) {
		$title       = get_the_title() . ' | ' . $site_name;
		$description = wp_trim_words( get_the_excerpt() ?: strip_tags( get_the_content() ), 60, '…' );
		$url         = get_permalink();
		$type        = 'article';
		if ( has_post_thumbnail() ) {
			$ogp_image = get_the_post_thumbnail_url( null, 'large' );
		}
	} else {
		$title       = $site_name . ' — ' . WPTS_SITE_TAGLINE;
		$description = WPTS_SITE_DESCRIPTION;
		$url         = $site_url;
		$type        = 'website';
	}

	$description = esc_attr( $description );
	$title       = esc_attr( $title );
	$url         = esc_url( $url );
	?>
<meta name="description" content="<?php echo $description; ?>">
<meta property="og:type"        content="<?php echo $type; ?>">
<meta property="og:title"       content="<?php echo $title; ?>">
<meta property="og:description" content="<?php echo $description; ?>">
<meta property="og:url"         content="<?php echo $url; ?>">
<meta property="og:site_name"   content="<?php echo esc_attr( $site_name ); ?>">
<meta property="og:image"       content="<?php echo esc_url( $ogp_image ); ?>">
<meta name="twitter:card"       content="summary_large_image">
<meta name="twitter:site"       content="<?php echo esc_attr( $twitter_id ); ?>">
<meta name="twitter:title"      content="<?php echo $title; ?>">
<meta name="twitter:description" content="<?php echo $description; ?>">
<meta name="twitter:image"      content="<?php echo esc_url( $ogp_image ); ?>">
	<?php
}
add_action( 'wp_head', 'wpts_ogp_meta' );
