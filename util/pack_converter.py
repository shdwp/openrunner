import json


pack_name = "core"
pack = json.load(open("../assets/netrunner-cards-json/pack/{}.json".format(pack_name)))

limit_to = """Hostile Takeover
Posted Bounty
Priority Requisition
Private Security Force
Adonis Campaign
Melange Mining Corp.
PAD Campaign
Anonymous Tip
Beanstalk Royalties
Hedge Fund
Shipment from Kaguya
Hadrian's Wall
Ice Wall
Wall of Static
Enigma
Tollbooth
Archer
Rototurret
Shadow
Diesel
Easy Mark
Infiltration
Modded
Sure Gamble
The Maker's Eye
Tinkering
Akamatsu Mem Chip
Cyberfeeder
Rabbit Hole
The Personal Touch
The Toolbox
Armitage Codebusting
Sacrificial Construct
Corroder
Crypsis
Femme Fatale
Gordian Blade
Ninja
Magnum Opus""".split()

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
    if limit_to and item not in limit_to:
        return
    
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
