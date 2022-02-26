from bs4 import BeautifulSoup
from product import Product
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager


def getProducts(query):

    source = "ETSY"

    etsyLink = "https://www.etsy.com/au"
    searchPrefix = "search?q="
    url = f"{etsyLink}/{searchPrefix}{query}"

    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("headless")

    driver = webdriver.Chrome(
        ChromeDriverManager().install(), options=chrome_options)
    driver.get(url)

    soup = BeautifulSoup(driver.page_source, 'html.parser')
    webProducts = soup.find_all(
        "div", class_="v2-listing-card")
    print(len(webProducts))

    products = []

    for product in webProducts:

        # title
        title_h3 = product.find('h3', class_="v2-listing-card__title")
        product_title_text = title_h3.text.strip()
        print(title_h3.text.strip())

        # pricing

        pricingDiv = product.find('div', class_="n-listing-card__price")

        sale_price_p = pricingDiv.find(
            'p', class_="search-collage-promotion-price")
        if sale_price_p == None:
            org_price_p = pricingDiv.find('p', class_="wt-text-title-01")
            org_price_span = org_price_p.find('span', class_="currency-value")
            price = org_price_span.text
        else:
            sale_price_span = sale_price_p.find(
                'span', class_="currency-value")
            price = sale_price_span.text
        price = price.replace(',', '')
        print(price)

        # image
        product_image_div = product.find('div', class_='v2-listing-card__img')
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


getProducts('ring')
