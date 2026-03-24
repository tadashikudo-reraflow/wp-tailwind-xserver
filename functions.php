<?php
/**
 * ReraFlow Theme Functions
 */

if ( ! defined( 'ABSPATH' ) ) exit;

/**
 * Enqueue styles
 */
function reraflow_enqueue_styles() {
	// Tailwind CSS
	wp_enqueue_style(
		'reraflow-tailwind',
		get_template_directory_uri() . '/assets/css/tailwind.css',
		[],
		filemtime( get_template_directory() . '/assets/css/tailwind.css' )
	);

	// Google Fonts
	wp_enqueue_style(
		'reraflow-fonts',
		'https://fonts.googleapis.com/css2?family=Inter:wght@300;400&family=Noto+Sans+JP:wght@400;600;700;900&display=swap',
		[],
		null
	);

	// WP ブロック CSS を除外（純粋 HTML パターンを使用するため不要）
	wp_dequeue_style( 'wp-block-library' );
	wp_dequeue_style( 'wp-block-library-theme' );
	wp_dequeue_style( 'global-styles' );
	wp_dequeue_style( 'classic-theme-styles' );
}
add_action( 'wp_enqueue_scripts', 'reraflow_enqueue_styles', 100 );

/**
 * Register block pattern category
 */
function reraflow_register_pattern_categories() {
	register_block_pattern_category( 'reraflow', [
		'label' => 'ReraFlow',
	] );
}
add_action( 'init', 'reraflow_register_pattern_categories' );

/**
 * Theme setup
 */
function reraflow_setup() {
	add_theme_support( 'title-tag' );
	add_theme_support( 'post-thumbnails' );
	add_theme_support( 'responsive-embeds' );
}
add_action( 'after_setup_theme', 'reraflow_setup' );
