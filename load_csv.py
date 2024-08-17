
import pandas as pd
from sqlalchemy import create_engine



db = create_engine('postgresql://postgres:hamza@localhost/painting')
conn = db.connect()

files = ['artist', 'canvas_size', 'image_link', 'museum_hours', 'museum', 'product_size', 'subject', 'work']

for file in files:
    df = pd.read_csv(f'./{file}.csv')
    df.to_sql(file, con=conn, if_exists='replace', index=False)