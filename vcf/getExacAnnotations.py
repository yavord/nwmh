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
            # check if there's allele freq or consequence data available, then append it to annotations
            try:
                annotations.append(data.json()["variant"]["allele_freq"])
                print("FREQ FOUND: {}".format(var))
            except KeyError: # catch missing allele_freq
                annotations.append(".")
                print("allele_freq for {} not found".format(var))
            try:
                annotations.extend(list(data.json()["consequence"].keys()))
                print("CSQS FOUND: {}".format(var))
            except AttributeError: # catch missing consequence
                annotations.append(".")
                print("consequence for {} not found".format(var))
        elif data.ok == False:
            print("Variant {} not found".format(var))

    return(annotations)

file = "test.txt"
x = getAnnotations(file)
print(x)
# prettyprint(x)
