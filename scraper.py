from bs4 import BeautifulSoup
import requests

websites = {"ebay": "ebay.com.au/sch/i.html?_nkw=", "amazon": "amazon.com.au/s?k="}

query = input("Enter item: ")

for site, url in websites.items():
    page = requests.get("https://" + url + query)
    soup = BeautifulSoup(page.content, 'html.parser')

    print(soup.find_all('h3')['s-item__title'])
    # print(soup.prettify())
    print("-----------------------------------------------------") 
