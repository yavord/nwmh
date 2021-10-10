import requests
import json
import pprint

prettyprint = pprint.PrettyPrinter(indent=2).pprint

# return list of variants in exac variant ID format
def getVariantList(fileName) :
    file = open(fileName, "r")
    variantList = [x.rstrip('\r\n') for x in file.readlines()]
    file.close()
    # final = json.dumps(query)
    return(variantList)

# GET variant info from exac API
def fetch(variantStr, url = "http://exac.hms.harvard.edu/rest/variant/") :
    # header = {"Content-Type": "application/json"}
    requestUrl = url + variantStr
    response = requests.get(requestUrl)
    return(response)

# return list of wanted annotations per variant
def getAnnotations(fileName) :
    annotations = []
    variantList = getVariantList(fileName)

    for var in variantList:
        data = fetch(variantStr=var)
        # prettyprint(data.json())
        # check if each variant exists on the ExAC database
        if data.ok == True:
            # check if there's allele freq and consequence data available
            try:
                annotations.append(data.json()["variant"]["allele_freq"])
                print(data.json()["variant"]["allele_freq"])
            except KeyError:
                annotations.append(".")
                print("allele_freq for {} not found".format(var))
            # try:
            #     annotations.append(data.json()["consequence"])
            #     print(data.json()["consequence"])
            # except:
            #     print("consequence for {} not found".format(var))
        elif data.ok == False:
            print("Variant {} not found".format(var))
        
    return(annotations)

file = "test.txt"
# v = "14-21853913-T-C"
# v2 = "1-115252203-G-A"
# l = [v, v2]
# r = fetch(variantStr=l[0]).json()
# r2 = fetch(variantStr=l[1]).json()

# prettyprint(r)
# prettyprint(r2)
# print(r['variant']['allele_freq'])

x = getAnnotations(file)
prettyprint(x)
