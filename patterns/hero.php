<?php
/**
 * Title: Hero
 * Slug: wpts/hero
 * Categories: wpts
 * Description: Full-width hero section with gradient background and geometric line art.
 */
?>

<!-- wp:group {"align":"full","className":"hero-section","gradient":"hero","layout":{"type":"constrained"},"style":{"spacing":{"padding":{"top":"160px","bottom":"120px"}}}} -->
<div class="wp-block-group alignfull hero-section has-hero-gradient-background">

	<!-- wp:group {"className":"hero-content","layout":{"type":"constrained","contentSize":"800px"},"style":{"spacing":{"blockGap":"24px"}}} -->
	<div class="wp-block-group hero-content">

		<!-- wp:paragraph {"align":"center","className":"hero-en-display","style":{"typography":{"fontSize":"5rem","fontWeight":"300","letterSpacing":"-0.02em","lineHeight":"1.1"},"color":{"text":"rgba(255,255,255,0.9)"}}} -->
		<p class="has-text-align-center hero-en-display" style="color:rgba(255,255,255,0.9);font-size:5rem;font-weight:300;letter-spacing:-0.02em;line-height:1.1">Your Tagline Here</p>
		<!-- /wp:paragraph -->

		<!-- wp:heading {"textAlign":"center","level":1,"style":{"typography":{"fontSize":"1.75rem","fontWeight":"700","lineHeight":"1.6"},"color":{"text":"var:preset|color|white"}}} -->
		<h1 class="wp-block-heading has-text-align-center has-white-color" style="font-size:1.75rem;font-weight:700;line-height:1.6">Your headline describing what you do</h1>
		<!-- /wp:heading -->

		<!-- wp:paragraph {"align":"center","style":{"typography":{"fontSize":"1rem","lineHeight":"1.8"},"color":{"text":"rgba(40,60,110,0.75)"}}} -->
		<p class="has-text-align-center" style="color:rgba(40,60,110,0.75)">Short description of your services or value proposition<br>Second line of description</p>
		<!-- /wp:paragraph -->

		<!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"},"style":{"spacing":{"margin":{"top":"40px"}}}} -->
		<div class="wp-block-buttons">
			<!-- wp:button {"backgroundColor":"white","textColor":"emphasis","style":{"border":{"radius":"8px"},"spacing":{"padding":{"top":"16px","bottom":"16px","left":"40px","right":"40px"}},"typography":{"fontSize":"1rem","fontWeight":"600"}}} -->
			<div class="wp-block-button" style="font-size:1rem;font-weight:600">
				<a class="wp-block-button__link has-white-background-color has-emphasis-color wp-element-button" href="#contact" style="border-radius:8px;padding-top:16px;padding-bottom:16px;padding-left:40px;padding-right:40px">Contact Us</a>
			</div>
			<!-- /wp:button -->
		</div>
		<!-- /wp:buttons -->

	</div>
	<!-- /wp:group -->

</div>
<!-- /wp:group -->
