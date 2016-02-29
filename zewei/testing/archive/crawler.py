import requests
from bs4 import BeautifulSoup

res = requests.post("http://localhost:3000/login", data={'email':"test", 'password':"test"})
#print(res.status_code, res.reason)
#print(res.text)

soup = BeautifulSoup(res.text, 'html.parser')
#hrefs = select(soup, "a.href")
print(soup.prettify())

for link in soup.find_all('a'):
    print(link.get('href'))

soup.p['class']
