from bs4 import BeautifulSoup
import requests

ebay = "ebay.com.au"
amazon = "amazon.com.au"
page = requests.get("https://" + amazon)
soup = BeautifulSoup(page.content, 'html.parser')

print(soup.title) 
