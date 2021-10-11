import requests
import json

# return list of lists of variants in exac variant ID format
def getVariantList(fileName) :
    file = open(fileName, "r")
    variantList = [x.rstrip('\r\n') for x in file.readlines()]
    final = [x.split(",") for x in variantList]
    # final = json.dumps()
    return(final)

# GET variant info from exac API
def fetch(variantStr, url = "http://exac.hms.harvard.edu/rest/variant/") :
    # header = {"Content-Type": "application/json"}
    requestUrl = url + variantStr
    response = requests.get(requestUrl)
    return(response)

# Returns string of consequence abbreviations
def abbrevCSQ(csqs) :
    csqString = []
    for csq in csqs:
        if csq == "5_prime_UTR_variant":
            csqString.append("5PU")
        elif csq == "splice_region_variant":
            csqString.append("SPL")
        elif csq == "non_coding_transcript_exon_variant":
            csqString.append("NCT")
        elif csq == "3_prime_UTR_variant":
            csqString.append("3PU")
        elif csq == "intron_variant":
            csqString.append("INT")
        elif csq == "missense_variant":
            csqString.append("MIS")
        elif csq == "synonymous_variant":
            csqString.append("SYN")
    finalString = ",".join(csqString)
    return(finalString)

# return list of wanted annotations per variant
def getAnnotations(fileName="../input/exacQuery.txt") :
    print("Getting ExAC annotations (this may take a few minutes)")
    annotations = []
    variantLists = getVariantList(fileName)

    for variantList in variantLists:
        annotation = [[],[]] # annotation per .vcf row
        for var in variantList:
            data = fetch(variantStr=var)
            # check if each variant exists on the ExAC database
            if data.ok == True:
                # check if there's allele freq or consequence data available 
                # then append it to annotation
                try:
                    frequency = data.json()["variant"]["allele_freq"]
                    annotation[0].append(str(frequency))
                except KeyError: # catch missing allele_freq
                    annotation[0].append(".")
                try:
                    csqs = abbrevCSQ(list(data.json()["consequence"].keys()))
                    annotation[1].append(csqs)
                except AttributeError: # catch missing consequence
                    annotation[1].append(".")
            elif data.ok == False:
                print("Variant {} not found".format(var))
        for i,l in enumerate(annotation): # join allele_freq and consequences 
            annotation[i] = ",".join(l)
        annotations.append(";".join(annotation)) # .vcf row to all
        
    return(annotations)

annotations = getAnnotations()

print("Done")

with open("../input/exacAnnotations.txt", "w+") as f:
    for annotation in annotations:
        f.write("%s\n" % annotation)
