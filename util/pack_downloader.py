import json
from os import path
import urllib.request

core_set = json.load(open("../assets/json/pack/core.json"))

for card in core_set:
    filename = "../assets/cards/{}.jpg".format(int(card["code"]))
    if not path.exists(filename):
        print(card["code"])
        urllib.request.urlretrieve("https://netrunnerdb.com/card_image/large/{}.jpg".format(card["code"]), filename)
