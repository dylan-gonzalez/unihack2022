import amazonScraper
import ebayScraper

MAX_LIMIT = 25

query = input('Query: ')
query = query.replace(' ', '+')

products = []


# get products
amazonProducts = amazonScraper.getProducts(query)
ebayProducts = ebayScraper.getProducts(query)

products = products + amazonProducts + ebayProducts


# Analyse products

totalPrice = 0
minPrice = None
maxPrice = None
for product in products:
    if minPrice == None or minPrice > product.price:
        minPrice = product.price
    if maxPrice == None or maxPrice < product.price:
        maxPrice = product.price
    totalPrice += product.price
averagePrice = totalPrice / len(products)

print(f"minPrice: {minPrice}")
print(f"maxPrice: {maxPrice}")
print(f"average Price: {averagePrice}")
print(f"products count: {len(products)}")


# for p in products:
#     print(p.title)
#     print(p.price)
#     print(p.image)
#     print(p.url)
#     print("----------")
