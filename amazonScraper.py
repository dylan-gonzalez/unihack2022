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
    print(product_title.text)


# print(products[0])
