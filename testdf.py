#!/usr/bin/python
import pandas as pd
pd.set_option('display.max_rows', 999)
d = {'one' : [1., 2., 3., 4.],
    'two' : [4., 3., 2., 1.]}
a = pd.DataFrame(d)
print(a.to_string())
