import imp
import readline

import amazonScraper
import ebayScraper

query = input('Query: ')
query = query.replace(' ', '+')

products = []

amazonProducts = amazonScraper.getProducts()


products = products + amazonProducts
