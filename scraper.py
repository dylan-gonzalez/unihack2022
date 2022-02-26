from bs4 import BeautifulSoup
import requests

# websites = {"ebay": "ebay.com.au/sch/i.html?_nkw=", "amazon": "amazon.com.au/s?k="}

ebay ="ebay.com.au/sch/i.html?_nkw=" 

# query = input("Enter item: ")
query = "laptop"

# for site, url in websites.items():
page = requests.get(f"https://{ebay}{query}")
soup = BeautifulSoup(page.content, 'html.parser')



# li_el = soup.find_all('li', {'data-view': "mi:1686|"})
for tag in soup.find_all(id = "srp-river-results"):
    ul = tag.find('ul', class_ = "srp-results").find_all("li", class_="s-item")

    print(ul[0].find('div', class_="s-item__info").find("a", class_="s-item__link"))



# print(srp_results)
print("-----------------------------------------------------") 
