<?php
/**
 * Title: CTA
 * Slug: wpts/cta
 * Categories: wpts
 * Description: Call-to-action section with accent background.
 */
?>

<!-- wp:group {"align":"full","className":"cta-section","style":{"spacing":{"padding":{"top":"80px","bottom":"80px"}},"color":{"background":"var:preset|color|accent"}},"layout":{"type":"constrained","contentSize":"640px"}} -->
<div id="contact" class="wp-block-group alignfull cta-section has-accent-background-color">

	<!-- wp:heading {"textAlign":"center","level":2,"style":{"typography":{"fontSize":"1.75rem","fontWeight":"700"}}} -->
	<h2 class="wp-block-heading has-text-align-center" style="font-size:1.75rem;font-weight:700">Get in Touch</h2>
	<!-- /wp:heading -->

	<!-- wp:paragraph {"align":"center","style":{"typography":{"fontSize":"1rem","lineHeight":"1.8"},"color":{"text":"var:preset|color|text-light"},"spacing":{"margin":{"top":"16px","bottom":"32px"}}}} -->
	<p class="has-text-align-center has-text-light-color" style="font-size:1rem;line-height:1.8">Have a question or want to work together?<br>We'd love to hear from you.</p>
	<!-- /wp:paragraph -->

	<!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
	<div class="wp-block-buttons">
		<!-- wp:button {"backgroundColor":"emphasis","textColor":"white","style":{"border":{"radius":"8px"},"spacing":{"padding":{"top":"16px","bottom":"16px","left":"48px","right":"48px"}},"typography":{"fontSize":"1rem","fontWeight":"600"}}} -->
		<div class="wp-block-button" style="font-size:1rem;font-weight:600">
			<a class="wp-block-button__link has-emphasis-background-color has-white-color wp-element-button" href="mailto:info@example.com" style="border-radius:8px;padding-top:16px;padding-bottom:16px;padding-left:48px;padding-right:48px">Send Email</a>
		</div>
		<!-- /wp:button -->
	</div>
	<!-- /wp:buttons -->

</div>
<!-- /wp:group -->
