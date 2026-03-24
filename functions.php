<?php
/**
 * WP Tailwind Starter — Functions
 *
 * Minimal functions.php for FSE block theme.
 * Most styling is handled by theme.json + Tailwind CSS.
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Enqueue Tailwind-built CSS
 */
function wpts_enqueue_styles() {
	wp_enqueue_style(
		'wpts-tailwind',
		get_template_directory_uri() . '/assets/css/tailwind.css',
		array(),
		filemtime( get_template_directory() . '/assets/css/tailwind.css' )
	);

	// Google Fonts — edit as needed
	wp_enqueue_style(
		'wpts-fonts',
		'https://fonts.googleapis.com/css2?family=Inter:wght@300;400&family=Noto+Sans+JP:wght@400;600;700;900&display=swap',
		array(),
		null
	);
}
add_action( 'wp_enqueue_scripts', 'wpts_enqueue_styles' );

/**
 * Register block patterns category
 */
function wpts_register_pattern_categories() {
	register_block_pattern_category( 'wpts', array(
		'label' => __( 'Starter', 'wpts' ),
	) );
}
add_action( 'init', 'wpts_register_pattern_categories' );

/**
 * Theme setup
 */
function wpts_setup() {
	add_theme_support( 'wp-block-styles' );
	add_theme_support( 'editor-styles' );
	add_theme_support( 'responsive-embeds' );
}
add_action( 'after_setup_theme', 'wpts_setup' );
