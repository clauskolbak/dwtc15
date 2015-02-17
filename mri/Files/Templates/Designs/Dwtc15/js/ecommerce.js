function confirmation(urlredirect, question) {
	var answer = confirm(question)
	if (answer) {
		window.location = urlredirect;
	}
}

function setVariant(variantUrl) {
	window.location = variantUrl;
}