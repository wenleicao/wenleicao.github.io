import pandas as pd
import time
import boto3
#below function are created for S3 table

def  athena_query_for_s3_table(catalog, database, query, workgroup ='your-work-group',env = 'pc_dev', custom_data_type_mapping={}):
    '''
    database = 'pc_xxxx'
    catalog = 'your-catalog'
    query = "SELECT * FROM table_name LIMIT 1500" 
    workgroup = 'your-work-group'
    df = athena_query_for_s3_table(catalog, database, query, workgroup) 
    df.shape    
    '''
    
    queryExecutionId = athena_get_executionid(catalog, database, query, workgroup, env) 
    response, column_metadata  = athena_get_query_results(queryExecutionId, env)
    #print(response)
    df = convert_s3_table_query_result_to_df(response, column_metadata, custom_data_type_mapping)
    return  df



def athena_get_executionid (catalog, database, query, workgroup ='your-work-group', env = 'pc_dev'):    
    athena_client = client(env)
    response = athena_client.start_query_execution(    #get executionid
        QueryString=query,
        QueryExecutionContext={
            'Database': database,
            'Catalog':  catalog
        },        
        WorkGroup=workgroup
    )    
    return response['QueryExecutionId']

def athena_s3_loop_through_results(query_execution_id = '074d491a-652d-42a9-8da3-a0135aaf6e82', env ='pc_dev' ):
    results = []
    next_token = None     
    athena_client = client(env)
    while True:
        if next_token:
            response = athena_client.get_query_results(QueryExecutionId=query_execution_id, NextToken=next_token)
        else:
            response = athena_client.get_query_results(QueryExecutionId=query_execution_id)
    
        results.extend(response['ResultSet']['Rows'])
    
        next_token = response.get('NextToken')
        if not next_token:
            break
    column_info = response['ResultSet']['ResultSetMetadata']['ColumnInfo']
    column_names = [col['Name'] for col in column_info]
    column_types = [col['Type'] for col in column_info]
    column_metadata = dict(zip(column_names, column_types))
    return results, column_metadata

def athena_get_query_results(query_execution_id, env):
    athena_client = client(env) 
    # Wait for the query to complete
    while True:
        #print ("Getting result")
        response = athena_client.get_query_execution(QueryExecutionId=query_execution_id)        
        status = response['QueryExecution']['Status']['State']
        if status in ['SUCCEEDED', 'FAILED', 'CANCELLED']:
            break
        time.sleep(5)   
    if status == 'SUCCEEDED':
            results, column_metadata = athena_s3_loop_through_results(query_execution_id, env)
            return results, column_metadata
    else:
        raise Exception(f"Query failed with status: {response}")
    
def convert_s3_table_query_result_to_df (results, column_metadata, custom_data_type_mapping={}):
    '''
    convert s3 table query result into df, please note: all s3 table is in varchart format at this stage
    need to convert to appropriate data type before join with others. Often time, it is better to do individual column type cast  

    '''   
    rows = results
    column_names = column_metadata.keys()
    if len(rows) <= 1:
        df = pd.DataFrame(columns=column_names)
        return df
    data_rows = rows[1:]  # Skip header row

    # Format data into a list of lists
    data = []
    for row in data_rows:
        data.append([item.get('VarCharValue') for item in row['Data']])

    # Create the Pandas DataFrame
    df = pd.DataFrame(data, columns=column_names)    
    # if column_metadata:    #due to hive and python data type range not match this often lead OverflowError
    #     for k, v in column_metadata.items():
    #         ptype = hive_to_python_type(v)
    #         df[k] = df[k].astype(ptype)
    if custom_data_type_mapping:        
        for k, v in custom_data_type_mapping.items():
            df[k] = df[k].astype(v)            
    return df 

def hive_to_python_type(hive_type):
    """
    Converts a Hive data type to its corresponding Python data type.

    Args:
        hive_type (str): The Hive data type.

    Returns:
        type: The Python data type, or None if the Hive type is unknown.
    """
    hive_type = hive_type.lower()
    if hive_type in ('string', 'varchar'):
        return str
    elif hive_type in ('int', 'tinyint', 'smallint'):
        return int
    elif hive_type == 'bigint':
        return int
    elif hive_type in ('float', 'double'):
        return float
    elif hive_type == 'boolean':
        return bool
    elif hive_type == 'timestamp':
         return str
    elif hive_type == 'date':
        return str
    elif hive_type.startswith('decimal'):
        return float
    elif hive_type.startswith('array'):
      return list
    elif hive_type.startswith('map'):
      return dict
    elif hive_type.startswith('struct'):
      return dict
    else:
        return None