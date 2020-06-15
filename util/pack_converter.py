import json

pack_name = "core"
pack = json.load(open("../assets/netrunner-cards-json/pack/{}.json".format(pack_name)))

buf = ""


def output(str):
    global buf
    buf += str

    
def escape(item):
    if type(item) == str:
        escapted_item = item.replace("\"", "\\\"").replace("'", "\\'").replace("\n", "\\n")
        return "\"{}\"".format(escapted_item)
    elif type(item) == bool:
        return item and "true" or "false"
    else:
        return "{}".format(item)
    

def process_cardspec(item):
    output("cardspec.cards[{}] = ".format(int(item["code"])))

    output("{\n")
    for k, v in item.items():
        output("    {} = {},\n".format(k, escape(v)))
    output("}\n")

    output("cardspec.card_titles[{}] = {}\n\n".format(escape(item["title"]), escape(int(item["code"]))))


for spec in pack:
    process_cardspec(spec)

with open("../app/scripts/cardspec/packs/{}.lua".format(pack_name), "w") as f:
    f.write(buf)
    f.close()
