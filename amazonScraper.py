from bs4 import BeautifulSoup
import requests

amazonLink = "https://www.amazon.com.au/s?k="
query = "flower"
page = requests.get(f"{amazonLink}{query}")
soup = BeautifulSoup(page.content, 'html.parser')

print(soup)
