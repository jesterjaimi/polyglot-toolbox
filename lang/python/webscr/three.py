import requests
from bs4 import BeautifulSoup
import csv

amzn_list = ['B002EYASY8','B74HL9TL8']

headers = {'User-Agent': 'Mozilla/5.0'}

csvFile = open("amzn.csv", 'wt')
write = csv.writer(csvFile)

for i in amzn_list:
	csvRow = []
	url = "http://www.amazon.com/dp/"+i
	print ("Processing: "+url)
	page = requests.get(url, headers=headers)
	bsobj = BeautifulSoup(page.content,"html.parser")
	#print (bsobj)
	product = bsobj.find("span",{"id":"productTitle"})
	price = bsobj.find("span",{"id":"priceblock_ourprice"})
	print (product)
	print (price)

