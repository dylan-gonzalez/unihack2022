from bs4 import BeautifulSoup
import requests

# This is what the link looks like: https://www.gumtree.com.au/s-QUERY/k0

amazonLink = "https://www.gumtree.com.au/s-"
query = "flower"
linkend = "/k0"
page = requests.get(f"{amazonLink}{query}{linkend}")
soup = BeautifulSoup(page.content, 'html.parser')


products = soup.find_all("div", class_="user-ad-row-new-design__salary-detail")

for product in products:
    product_title = product.find(
        "span", class_="user-ad-row-new-design__title-span")
    if product_title == None:
        continue
    print(product_title.text)


# print(products[0])
