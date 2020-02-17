import pandas as pd
import numpy as np
import gzip
import requests
from io import StringIO


##### 1. make country_df

def make_df_from_sub_url(country_url):
    ### download and unpack file from base_url + country_url
    ### apply create_country_flights_df to the downloaded file
    ### returns a dataframe
    
    # define url
    base_url = "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/"
    url = base_url + country_url

    # make request, unpack its content, decode bytes to uft8-str, StringIO to make readable csv-like, read_csv
    return create_country_flights_df(pd.read_csv(StringIO(gzip
                                                          .decompress(requests
                                                                      .get(url)
                                                                      .content)
                                                          .decode("utf-8")),sep="\t"))


######### 2. Transform country_df

def create_country_flights_df(df_in):
    ### take a dataframe in the form provided by eurostat and transform
    ### returns a dataframe
    
    df = df_in.copy()
    # strip spaces from column names
    df.rename(columns=lambda x: x.strip(), inplace=True)
    
    # rename first columns
    df.columns = ["info"] + list(df.columns[1:])
    
    # take only those columns with monthly data
    df = df[["info"] + [col for col in df.columns[1:] if ("M" in col)]]
    
    # strip spaces in all columns !!!!!!!!!!!!!!!! ineffective??? !!!!!!!!!!!1
    for col in df.columns:
        df[col] = df[col].apply(lambda x: x.strip())
        
    #write proper nans and make all float
    df = pd.DataFrame(np.where(df.eq(":"),np.nan,df),columns = df.columns)
    df[df.columns[1:]] = df.iloc[:,1:].astype(float)
    
    # create a new table with all the infos from all month-columns
    df_fin = pd.DataFrame(columns = ["info","value","date"])
    for date in df.columns[1:]:
        date_proper = date[:4] + "-" + date[-2:]
        df_fin = pd.concat(([df_fin,
                            (df.loc[~df[date].isna(),["info",date]].
                             assign(date=[date_proper]*len(df[~df[date].isna()])).
                             rename(columns = {date:"value"}))]),
                          axis = 0,
                          ignore_index = True)
    df_fin["date"] = pd.to_datetime(df_fin["date"],format = "%Y-%m")
    
    # take apart the first column to retrieve the three pieces of info
    df_fin[["type1","type2","flight"]] = pd.DataFrame(df_fin["info"].str.split(",").values.tolist(),index= df_fin.index)
    
    # take appart even further
    df_fin[["fr_country","fr_airport","to_country","to_airport"]] = pd.DataFrame(df_fin["flight"].str.split("_").values.tolist(),index= df_fin.index)
    
    # reorder columns and return result
    return df_fin[["flight","fr_country","fr_airport","to_country","to_airport","date","type1","type2","value"]]


######## 3. filter relevant columns
def filter_out_arr_dep(_df_):
    ### filter for only flights, seats and passengers
    filter_list = (["PAS_BRD_DEP",
                    "ST_PAS_DEP",
                    "CAF_PAS_DEP"])
    return _df_.loc[_df_["type2"].isin(filter_list)].reset_index(drop=True)



######## 4. merge to final df

def merge_to_final_df(_df_):
    ### take all the informaton from all routes, and create a df, with a single row for every rout
    col_sub_list = ["flight","date","value"]
    col_sub_list_long = ["flight","fr_country","fr_airport","to_country","to_airport","date","value"]

   
    caf_dep = _df_.loc[_df_["type2"].eq("CAF_PAS_DEP"),col_sub_list_long].rename(columns = {"value":"flight_d"})
    st_dep  = _df_.loc[_df_["type2"].eq("ST_PAS_DEP"),col_sub_list].rename(columns = {"value":"seat_d"})
    pas_dep = _df_.loc[_df_["type2"].eq("PAS_BRD_DEP"),col_sub_list].rename(columns = {"value":"passenger_d"})
    

    return (caf_dep
            .merge(right = st_dep, how = "inner", on = ["flight","date"])
            .merge(right = pas_dep, how = "inner", on = ["flight","date"])
           )



###### 5. putting it all together

def load_and_transform_data(country_sub_url):
    ##input: country_sub_url
    ## output: transformed dataframe
    
    # step 1: load data
    df  = make_df_from_sub_url(country_sub_url)
    # step 2: filter relevant data
    df = filter_out_arr_dep(df)
    # step 3: do merge to get sum of flights, passengers and seats for each connection
    return merge_to_final_df(df).rename(columns = {"flight":"route","date":"month"})
    

