'''
this function can handle oracle script with block comment
handle change drop table table  to
begin execute immediate \'drop table UTLMGT_DASHBOARD.temp_gen_dm_auth_2\'; exception when others then null; end
'''

def convertToBODSScript ( path):
    f0 = open(path,'r')
    f1 = []
    for line in f0:
         if line.strip():
            f1.append(line)
    f0.close()
    isBegin = True
    isCommentBegin = False
    for line in f1:
        if isCommentBegin == False:
            if line.strip(' \t\n\r').startswith('/*') and 'parallel' not in line.lower():
                isCommentBegin = True
                line = '# ' + line
                if line.strip(' \t\n\r').endswith('*/') and 'parallel' not in line.lower():
                    isCommentBegin = False
                print (line)
                continue
            if line.lstrip(' \t\n\r').startswith('--'):
                line = '# ' + line
                
            else:
                if  line.lstrip(' \t\n\r').find('--') > 0:  # this handle in line comment 
                    line = line[0 :line.find('--')]  + '\n'
                line = line.replace("'", "\\'")
                if isBegin==True:
                    line ="sql('NATLDWH_UTLMGT_DASHBOARD','" + line
                    isBegin =False

                else:
                    line ="|| '" + line
                    isBegin =False
                if line.rstrip(' \t\n\r').endswith(';'):
                    line =line.replace(';', " ');\n")
                    isBegin =True
                else:
                    line =line.rstrip(' \t\n\r') + " '\n"
                if  line.lower().find("'drop table ") >= 0:
                    line = line[0:line.lower().index("\'drop table ")] + "\'begin execute immediate \\" + line[line.lower().index("\'drop table "):line.index("\');")] + "\\\'; exception when others then null; end;\');" 
                if  line.lower().find("'drop index ") >= 0:
                    line = line[0:line.lower().index("\'drop index ")] + "\'begin execute immediate \\" + line[line.lower().index("\'drop index "):line.index("\');")] + "\\\'; exception when others then null; end;\');" 
            print (line)
        else:
            line = '# ' + line
            print(line)
            if line.strip(' \t\n\r').endswith('*/') and 'parallel' not in line.lower() :
                isCommentBegin = False
            

    #f1.close()

#convertToBODSScript (r'C:\Users\Wenlei\Desktop\sample.sql')

#convertToBODSScript (r'C:\Users\Wenlei\Desktop\sample2.sql')

convertToBODSScript ( r'C:\Users\Wenlei\Desktop\sample15.sql')
