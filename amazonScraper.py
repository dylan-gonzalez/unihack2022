from bs4 import BeautifulSoup
import requests

from product import Product


def getProducts(query):
    amazonLink = "https://www.amazon.com.au"
    amazonQueryPrefix = "s?k="
    page = requests.get(f"{amazonLink}/{amazonQueryPrefix}{query}")
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
        # print(product_title.text)

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

        product = Product(title=product_title.text, url=product_url['href'],
                          image=f"{amazonLink}{product_image_url}", price=float(product_price))
        products.append(product)
    return products
