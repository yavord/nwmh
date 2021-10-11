import requests
import json
import pprint

prettyprint = pprint.PrettyPrinter(indent=2).pprint

### this script returns unique consequences found for all ExAC variant queries

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
        # check if each variant exists on the ExAC database
        if data.ok == True:
            # check if there's consequence data available
            try:
                annotations = annotations + list(data.json()["consequence"].keys())
                print(list(data.json()["consequence"].keys()))
            except (KeyError, AttributeError):
                annotations.append(".")
                print("consequence for {} not found".format(var))
        elif data.ok == False:
            print("Variant {} not found".format(var))

    aSet = set(annotations)
    uniqueAnnotations = list(aSet)

    return(uniqueAnnotations)


# File input containing variant_strings
file = "test.txt"
x = getAnnotations(file)
print(x)
# prettyprint(x)
