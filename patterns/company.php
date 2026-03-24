<?php
/**
 * Title: Company
 * Slug: wpts/company
 * Categories: wpts
 * Description: Company overview section with table.
 */
?>

<!-- wp:group {"align":"full","className":"company-section","style":{"spacing":{"padding":{"top":"80px","bottom":"80px"}},"color":{"background":"var:preset|color|surface"}},"layout":{"type":"constrained"}} -->
<div id="company" class="wp-block-group alignfull company-section has-surface-background-color">

	<!-- wp:group {"layout":{"type":"constrained","contentSize":"800px"},"style":{"spacing":{"blockGap":"16px","margin":{"bottom":"48px"}}}} -->
	<div class="wp-block-group">
		<!-- wp:paragraph {"align":"center","className":"section-label-en","style":{"typography":{"fontSize":"0.875rem","fontWeight":"400","letterSpacing":"0.1em","textTransform":"uppercase"},"color":{"text":"var:preset|color|emphasis"}}} -->
		<p class="has-text-align-center section-label-en has-emphasis-color">company</p>
		<!-- /wp:paragraph -->

		<!-- wp:heading {"textAlign":"center","level":2,"style":{"typography":{"fontSize":"2rem","fontWeight":"700"}}} -->
		<h2 class="wp-block-heading has-text-align-center">About Us</h2>
		<!-- /wp:heading -->
	</div>
	<!-- /wp:group -->

	<!-- wp:group {"className":"company-card","style":{"color":{"background":"var:preset|color|white"},"border":{"radius":"16px"},"spacing":{"padding":{"top":"48px","bottom":"48px","left":"48px","right":"48px"}}},"layout":{"type":"constrained","contentSize":"900px"}} -->
	<div class="wp-block-group company-card">

		<!-- wp:table {"className":"company-table","style":{"typography":{"fontSize":"0.9375rem"}}} -->
		<figure class="wp-block-table company-table">
		<table>
			<tbody>
				<tr><th>Company</th><td>Your Company Name</td></tr>
				<tr><th>Founded</th><td>2025</td></tr>
				<tr><th>CEO</th><td>Your Name</td></tr>
				<tr><th>Services</th><td>Service 1 / Service 2 / Service 3</td></tr>
				<tr><th>Location</th><td>Your City, Country</td></tr>
				<tr><th>Email</th><td><a href="mailto:info@example.com">info@example.com</a></td></tr>
			</tbody>
		</table>
		</figure>
		<!-- /wp:table -->

	</div>
	<!-- /wp:group -->

</div>
<!-- /wp:group -->
