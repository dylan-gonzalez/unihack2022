from bs4 import BeautifulSoup
import requests
from product import Product
import math
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager


class ScraperAPI(object):
    def __init__(self, query: str):
        self.MAX_LIMIT = 75
        self.amazonLink = "https://www.amazon.com.au/s?k="
        self.amazonPagePrefix = "&page="
        self.ebayLink = "ebay.com.au/sch/i.html?_nkw="
        self.ebayPagePrefix = "&_pgn="
        self.etsyLink = "https://www.etsy.com/au"
        self.etsySearchPrefix = "search?q="

        query = query.replace(' ', '+')
        self.query = query

        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument("headless")

        self.driver = webdriver.Chrome(
            ChromeDriverManager().install(), options=chrome_options)

        self.products = []

    def getProducts(self):

        amazonProducts = self.getAmazonProducts()
        ebayProducts = self.getEbayProducts()

        self.products = self.products + amazonProducts + ebayProducts
        return self.products

    def getAmazonProducts(self):
        counter = 1
        source = "AMAZON"

        products = []

        while counter < self.MAX_LIMIT:
            print("AMAZON: NEW PAGE")
            url = f"{self.amazonLink}{self.query}{self.amazonPagePrefix}{math.ceil(counter / self.MAX_LIMIT)}"
            self.driver.get(url)

            soup = BeautifulSoup(self.driver.page_source, 'html.parser')

            webProducts = soup.find_all("div", class_="s-result-item")

            for product in webProducts:
                print("amazon counter: ", counter)
                # Product Title
                product_title = product.find(
                    "span", class_="a-size-base-plus a-color-base a-text-normal")

                # Product Price
                product_price_dollar = product.find(
                    "span", class_="a-price-whole")
                product_price_cent = product.find(
                    "span", class_="a-price-fraction")

                if product_title == None or product_price_dollar == None or product_price_cent == None:
                    continue

                try:
                    product_price = float(
                        f"{product_price_dollar.text}{product_price_cent.text}")
                except:
                    continue

                # Product Image
                product_image_div = product.find(
                    "div", class_="s-product-image-container")
                product_image_url = product_image_div.find(
                    "img", class_="s-image")

                # Product image
                product_url = product_image_div.find(
                    "a", class_="a-link-normal s-no-outline")

                product = Product(title=product_title.text, url=f"{self.amazonLink}{product_url['href']}", source=source,
                                  image=product_image_url['src'], price=product_price,)
                products.append(product)

                counter += 1

            print("products len: ", len(products))
            return products

    def getEtsyProducts(self):
        counter = 1
        products = []
        source = "ETSY"
        while counter < self.MAX_LIMIT:
            print("ETSY: NEW PAGE")
            url = f"{self.etsyLink}/{self.etsySearchPrefix}{query}"
            self.driver.get(url)

            soup = BeautifulSoup(self.driver.page_source, 'html.parser')
            webProducts = soup.find_all("div", class_="v2-listing-card")
            products = []

            for product in webProducts:

                # title
                title_h3 = product.find('h3', class_="v2-listing-card__title")
                product_title_text = title_h3.text.strip()
                print(title_h3.text.strip())

                # pricing

                pricingDiv = product.find(
                    'div', class_="n-listing-card__price")

                sale_price_p = pricingDiv.find(
                    'p', class_="search-collage-promotion-price")
                if sale_price_p == None:
                    org_price_p = pricingDiv.find(
                        'p', class_="wt-text-title-01")
                    org_price_span = org_price_p.find(
                        'span', class_="currency-value")
                    price = org_price_span.text
                else:
                    sale_price_span = sale_price_p.find(
                        'span', class_="currency-value")
                    price = sale_price_span.text
                price = price.replace(',', '')
                print(price)

                # image
                product_image_div = product.find(
                    'div', class_='v2-listing-card__img')
                product_image_img = product_image_div.find('img')
                product_image_url = product_image_img['src']
                print(product_image_url)

                # product link
                product_link_a = product.find('a', class_="listing-link")
                product_link_url = product_link_a['href']
                print(product_link_url)

                prod = Product(product_title_text, float(price), source,
                               product_image_url, product_link_url)

                products.append(prod)
        return products

    def getEbayProducts(self):
        counter = 1
        products = []
        source = "EBAY"

        while counter < self.MAX_LIMIT:
            print("EBAY: NEW PAGE")
            url = f"https://{self.ebayLink}{self.query}{self.ebayPagePrefix}{math.ceil(counter / self.MAX_LIMIT)}"
            self.driver.get(url)

            soup = BeautifulSoup(self.driver.page_source,
                                 'html.parser').find(id="srp-river-results")
            productsArray = soup.find(
                'ul', class_="srp-results").find_all("li", class_="s-item")

            # for tag in soup.find_all(id="srp-river-results"):
            # products_array = tag.find(
            #     'ul', class_="srp-results").find_all("li", class_="s-item")

            for p in productsArray:
                print(counter)
                image = p.find('img', class_="s-item__image-img")['src']
                info = p.find('div', class_="s-item__info")
                title = info.find("h3").text
                url = info.find("a", class_="s-item__link")['href']

                try:
                    price = float(
                        info.find("span", class_="s-item__price").text.strip("AU $").replace(",", ""))
                except:
                    continue

                product = Product(title, price, source, image, url)

                products.append(product)

                counter += 1

        # for p in products:
        #     print(p.title)
        #     print(p.price)
        #     print(p.image)
        #     print(p.url)
        #     print("----------")

        return products

    def analyseProducts(self):
        # Analyse products

        totalPrice = 0
        minPrice = None
        maxPrice = None
        for product in self.products:
            if minPrice == None or minPrice > product.price:
                minPrice = product.price
            if maxPrice == None or maxPrice < product.price:
                maxPrice = product.price
            totalPrice += product.price
        averagePrice = totalPrice / len(self.products)

        print(f"minPrice: {minPrice}")
        print(f"maxPrice: {maxPrice}")
        print(f"average Price: {averagePrice}")
        print(f"products count: {len(self.products)}")

        # for p in products:
        #     print(p.title)
        #     print(p.price)
        #     print(p.image)
        #     print(p.url)
        #     print("----------")


query = input('Query: ')
scraper = ScraperAPI(query)
products = scraper.getProducts()
# for p in products:
#     print (p.title)
#     print (p.price)
#     print("--------------------")
