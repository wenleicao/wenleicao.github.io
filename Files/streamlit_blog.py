import streamlit as st
import pandas as pd
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode, JsCode
from st_aggrid.grid_options_builder import GridOptionsBuilder



st.title('Streamlit reporting use cases')

car_data = {

"https://www.toyota.com": "Camry",

"https://www.honda.com": "Civic",

"https://www.ford.com": "Mustang",

"https://www.bmw.com": "X5"
}

df = pd.DataFrame(list(car_data.items()), columns=["URL", "Model"])

df['Model'] = df['URL'] + '#' + df['Model'] # Add Model to the URL

del (df['URL']) # We don’t need it anymore

st.subheader('Car Models not working')

st.dataframe(

df,

column_config={

    "Model": st.column_config.LinkColumn(

        "Car Model", display_text= r"https://.\*?#(.\*)$"    # This extracts anything in the URL after '#'
    )
},
hide_index=True

)


st.subheader('Car Models working')

st.dataframe(

df,

column_config={

    "Model": st.column_config.LinkColumn(

        "Car Model", display_text= ".*#(.*)"    # This extracts anything in the URL after '#'
    )
},
hide_index=True

)

st.subheader('drill down and drill up')

data = pd.DataFrame({"Region": ["East","East","West","West"],"City": ["NYC","Boston","LA","SF"],"Sales": [100, 150, 200, 300]
})

gb = GridOptionsBuilder.from_dataframe(data)
# Drill Down by Region -> City
gb.configure_column("Region", rowGroup=True, hide=True)
gb.configure_column("Sales", aggFunc="sum")
gb.configure_grid_options(domLayout='normal')

go = gb.build()
AgGrid(data, gridOptions=go, enable_enterprise_modules=True)


st.subheader('drill down and drill up, more complicated')

data = pd.DataFrame({"Region": ["East","East","East","West","West"],"City": ["NYC","Boston","NYC","LA","SF"],"Sales": [100, 150, 400, 200, 300]
})

gb = GridOptionsBuilder.from_dataframe(data)
# Drill Down by Region -> City
gb.configure_column("Region", rowGroup=True, hide=True)
gb.configure_column("Sales", aggFunc="sum")
gb.configure_column("City", rowGroup=True, hide=True)
gb.configure_column("trans_count", aggFunc="count")
gb.configure_grid_options(domLayout='normal')

go = gb.build()
AgGrid(data, gridOptions=go, enable_enterprise_modules=True)


