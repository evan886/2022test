#!/usr/bin/python3
import requests
from bs4 import BeautifulSoup
import operator
from collections import Counter

def start(url):
	wordlist = []
	source_code = requests.get(url).text

	soup = BeautifulSoup(source_code, 'html.parser')

	for each_text in soup.findAll('p'):
		content = each_text.text

		words = content.lower().split()

		for each_word in words:
			wordlist.append(each_word)
		clean_wordlist(wordlist)



def clean_wordlist(wordlist):

	clean_list = []
	for word in wordlist:
		symbols = "!@#$%^&*()_-+={[}]|\;:\"<>?/., "

		for i in range(len(symbols)):
			word = word.replace(symbols[i], '')

		if len(word) > 0:
			clean_list.append(word)
	create_dictionary(clean_list)


def create_dictionary(clean_list):
	word_count = {}

	for word in clean_list:
		if word in word_count:
			word_count[word] += 1
		else:
			word_count[word] = 1


	c = Counter(word_count)

	top = c.most_common(10)
	print(top)


if __name__ == '__main__':
	url = "http://54.215.65.27/"
	start(url)

