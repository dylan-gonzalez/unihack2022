from bs4 import BeautifulSoup
import requests

amazonLink = "https://www.amazon.com.au/s?k="
query = "flower"
page = requests.get(f"{amazonLink}{query}")
soup = BeautifulSoup(page.content, 'html.parser')


products = soup.find_all("div", class_="s-result-item")

for product in products:
    product_title = product.find(
        "span", class_="a-size-base-plus a-color-base a-text-normal")
    if product_title == None:
        continue
    # print(product_title.text)

    product_price_dollar = product.find("span", class_="a-price-whole")
    product_price_cent = product.find("span", class_="a-price-fraction")
    if product_price_dollar == None or product_price_cent == None:
        continue

    product_price = f"{product_price_dollar.text}{product_price_cent.text}"
    # print(product_price)

    product_image_div = product.find("div", class_="s-product-image-container")
    product_image_url = product_image_div.find("img", class_="s-image")
    print(product_image_url['src'])


# print(products[0])
