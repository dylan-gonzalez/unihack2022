from bs4 import BeautifulSoup
import requests
from product import Product


class ScraperAPI(object):

    def __init__(self, query: str):
        self.MAX_LIMIT = 25
        
        query = query.replace(' ', '+')
        self.query = query

        self.products = []

    def getProducts(self):
        amazonProducts = self.getAmazonProducts()
        ebayProducts = self.getEbayProducts()

        self.products = self.products + amazonProducts + ebayProducts
        return self.products

    def getAmazonProducts(self):
        amazonLink = "https://www.amazon.com.au"
        amazonQueryPrefix = "s?k="
        page = requests.get(f"{amazonLink}/{amazonQueryPrefix}{self.query}")
        # print(f"{amazonLink}/{amazonQueryPrefix}{query}")
        soup = BeautifulSoup(page.content, 'html.parser')
        # print(soup)
        webProducts = soup.find_all("div", class_="s-result-item")
        products = []

        for product in webProducts:
            # Product Title
            product_title = product.find(
                "span", class_="a-size-base-plus a-color-base a-text-normal")
            if product_title == None:
                continue

            # Product Price
            product_price_dollar = product.find("span", class_="a-price-whole")
            product_price_cent = product.find("span", class_="a-price-fraction")
            if product_price_dollar == None or product_price_cent == None:
                continue

            product_price = f"{product_price_dollar.text}{product_price_cent.text}"

            # Product Image
            product_image_div = product.find(
                "div", class_="s-product-image-container")
            product_image_url = product_image_div.find("img", class_="s-image")

            # Product image
            product_url = product_image_div.find(
                "a", class_="a-link-normal s-no-outline")

            product = Product(title=product_title.text, url=f"{amazonLink}{product_url['href']}",
                            image=product_image_url['src'], price=float(product_price))
            products.append(product)

        return products

    def getEbayProducts(self):
        ebay = "ebay.com.au/sch/i.html?_nkw="

        # for site, url in websites.items():
        page = requests.get(f"https://{ebay}{self.query}&")
        soup = BeautifulSoup(page.content, 'html.parser')

        products = []

        for tag in soup.find_all(id="srp-river-results"):
            products_array = tag.find(
                'ul', class_="srp-results").find_all("li", class_="s-item")

            for p in products_array:
                image = p.find('img', class_="s-item__image-img")['src']
                info = p.find('div', class_="s-item__info")
                title = info.find("h3").text
                url = info.find("a", class_="s-item__link")['href']

                try:
                    price = float(
                        info.find("span", class_="s-item__price").text.strip("AU $").replace(",", ""))
                except:
                    continue

                product = Product(title, price, image, url)

                products.append(product)

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
for p in products:
    print (p.title)
    print (p.price)
    print("--------------------")