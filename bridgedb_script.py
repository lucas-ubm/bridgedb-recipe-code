import requests
import pandas as pd

url = "https://webservice.bridgedb.org/"
single_request = url+"{org}/xrefs/{source}/{identifier}"
batch_request = url+"{org}/xrefsBatch/{source}"

def to_df(response, batch=False):
    if batch:
        records = []
        for tup in to_df(response).itertuples():
            if tup[3] != None:
                for mappings in tup[3].split(','):
                    target = mappings.split(':')
                    records.append((tup[1], tup[2], target[1], target[0]))
        return pd.DataFrame(records, columns = ['original', 'source', 'mapping', 'target'])
        
    return pd.DataFrame([line.split('\t') for line in response.text.split('\n')])

def get_mappings(file, org, source, case=1):
    names = ['source']
        
    if case==2:
        names = ['local'] + names
        
    data = pd.read_csv(file, sep='\t', header=None, names=names)
    
    response = requests.post(batch_request.format(org=org, source=source), data = data.source.to_csv(index=False, header=False))
    mapping = to_df(response, batch=True)
    
    if case == 2: 
        return mapping.join(data.set_index('source'), on='original')
    else:
        return mapping
        

