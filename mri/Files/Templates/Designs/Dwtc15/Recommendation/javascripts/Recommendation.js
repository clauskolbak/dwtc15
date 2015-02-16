(function (undefined) {
    "use strict";

    var parseQueryString = function (queryString) {
        var match,
            pl = new RegExp('\\+', 'g'),
            search = new RegExp('([^&=]+)=?([^&]*)', 'g'),
            decode = function (s) {
                return decodeURIComponent(s.replace(pl, ' '));
            },
            urlParams = {};

        if (queryString) {
            while (match = search.exec(queryString)) {
                urlParams[decode(match[1])] = decode(match[2]);
            }
        }

        return urlParams;
    },

    buildUrl = function (url, params) {
        var baseUrl = url,
            queryString = '',
            fragment = '',
            name,
            query,
            urlParams,
            match = new RegExp('^([^?#]+)?(?:\\?([^#]+))?(?:#(.+))?$').exec(url);

        if (match) {
            baseUrl = match[1];
            queryString = match[2] || null;
            fragment = match[3] || null;
        }

        urlParams = parseQueryString(queryString);
        for (name in params) {
            urlParams[name] = params[name];
        }

        query = [];
        for (name in urlParams) {
            query.push(encodeURIComponent(name) + '=' + encodeURIComponent(urlParams[name]));
        }

        return baseUrl + (query ? '?' + query.join('&') : '') + (fragment ? '#' + fragment : '');
    },

    addQueryString = function (url, queryStrings) {
        var i, queryString;
        for (i = 1; queryString = arguments[i]; i++) {
            url += (url.indexOf('?') < 0 ? '?' : '&') + queryString.replace(/^[?&]/, '');
        }
        return url;
    },

    getProductDetailsUrl = function (product, baseUrl) {
        var pageUrl, fragmentId = null,
            match;

        if (!baseUrl) {
            baseUrl = location.href;
        }

        var params = {
            ProductId: product.ID
        };
        if (product.VariantID) {
            params['VariantID'] = product.VariantID;
        }

        return buildUrl(baseUrl, params);
    },

    getImageUrl = function (pattern, product) {
        return pattern.replace('{ProductNumber}', product.Number);
    },

    getProductsQuery = function () {
        var attributeName = 'data-product-auto-id',
            productsIds = [],
            i, id, node,
            nodes = document.querySelectorAll('[' + attributeName + ']');
        for (i = 0; node = nodes[i]; i++) {
            id = parseInt(node.getAttribute(attributeName));
            if (!isNaN(id)) {
                productsIds.push(id);
            }
        }
        return productsIds.length > 0 ? 'product=' + productsIds.join('&product=') : null;
    },

    getProducts = function (data) {
        var i, product, products = null,
            settings;
        if (data) {
            products = data.Products;
            settings = data.Settings;
            if (products && settings) {
                for (i = 0; product = products[i]; i++) {
                    if (settings.ImageFolder) {
                        product.ImageUrlSmall = getImageUrl(settings.ImageFolder + settings.ImagePatternS, product);
                        product.ImageUrlMedium = getImageUrl(settings.ImageFolder + settings.ImagePatternM, product);
                        product.ImageUrlLarge = getImageUrl(settings.ImageFolder + settings.ImagePatternL, product);
                    }
                    product.ProductDetailsUrl = getProductDetailsUrl(product, settings.ShowOnParagraph ? settings.ShowOnParagraph : location.pathname + location.search);
                }
            }
        }
        return products;
    },

    loadRecommendations = function (config) {
        var url, request;
        config || (config = {});
        url = config.recommendationsUrl;
        if (url) {
            request = new XMLHttpRequest();
            request.onreadystatechange = function () {
                if (this.readyState === 4) {
                    if (this.status === 200) {
                        var data, products = null;
                        try {
                            data = JSON.parse(this.response.replace(/"_/g, '"'));
                            products = getProducts(data);
                        } catch (ignore) { }
                        config.renderProducts(products);
                    } else {
                        // ;;; console.debug('error', this);
                    }
                }
            }
            request.open('GET', url, true);
            request.setRequestHeader("Accept", "application/json");
            request.send();
        }
    };

    if (typeof window.Dynamicweb === 'undefined') {
        window.Dynamicweb = {};
    }

    window.Dynamicweb.Recommendation = {
        buildUrl: buildUrl,
        addQueryString: addQueryString,
        loadRecommendations: loadRecommendations
    };
}());