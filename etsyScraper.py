from bs4 import BeautifulSoup
from product import Product
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager


def getProducts(query):
    etsyLink = "https://www.etsy.com/au"
    searchPrefix = "search?q="
    url = f"{etsyLink}/{searchPrefix}{query}"

    driver = webdriver.Chrome(ChromeDriverManager().install())
    driver.get(url)

    soup = BeautifulSoup(driver.page_source, 'html.parser')
    webProducts = soup.find_all(
        "div", class_="v2-listing-card")
    print(len(webProducts))
    for product in webProducts:
        title_h3 = product.find('h3', class_="v2-listing-card__title")
        print(title_h3.text.strip())
        pricingDiv = product.find('div', class_="n-listing-card__price")

    products = []


getProducts('ring')
