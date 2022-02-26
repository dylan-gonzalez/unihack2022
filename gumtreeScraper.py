from bs4 import BeautifulSoup
import requests

# This is what the link looks like: https://www.gumtree.com.au/s-QUERY/k0

gumtreeLink = "https://www.gumtree.com.au/s-"
gumquery = "barbie"
linkend = "/k0"
page = requests.get(f"{gumtreeLink}{gumquery}{linkend}")
soup = BeautifulSoup(page.content, 'html.parser')


products = soup.find_all("a", class_="user-ad-row-new-design")


for product in products:

    product_title = product.find(
        "span", class_="user-ad-row-new-design__title-span")

    if product_title == None:
        continue
    print(product_title.text)

    product_price = product.find(
        "span", class_="user-ad-price-new-design__price")
    if product_price == None:
        continue
    print(product_price.text)

    product_location = product.find(
        "span", class_="user-ad-row-new-design__location")
    if product_location == None:
        continue
    print(product_location.text)


print(products[0])
