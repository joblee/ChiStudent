from bs4 import BeautifulSoup

file = open('CountryCode.txt', 'r')
fileContent = file.read()

soup = BeautifulSoup(fileContent)

countryList = []

#getText() is used to remove the text
for content in soup.find_all('tr'):
	countryName = content.find_all('td')[0].getText()
	phoneCode = content.find_all('td')[1].getText()
	countryList.append((countryName, phoneCode))


stringList = ""
for i in range(len(countryList)):
	stringList = stringList + "(\"" + countryList[i][0] + "\"" + "," + "\"" + countryList[i][1] + "\"" + "), " 
	
#print stringList

stringList = ""
for i in range(len(countryList)):
	stringList = stringList + "\"" + countryList[i][0] + "\", " 
	
#print stringList


stringList = ""
for i in range(len(countryList)):
	stringList = stringList + "\"" + countryList[i][0] + "," + countryList[i][1] + "\", "
	
print stringList
