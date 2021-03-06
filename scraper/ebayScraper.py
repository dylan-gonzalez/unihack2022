from bs4 import BeautifulSoup
import requests
from product import Product


def getProducts(query: str):
    ebay = "ebay.com.au/sch/i.html?_nkw="

    # for site, url in websites.items():
    page = requests.get(f"https://{ebay}{query}&")
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

print(getProducts("laptop"))