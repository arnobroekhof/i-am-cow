#!/usr/bin/env python

import cowsay
import pandas as pd


if __name__ == '__main__':
    data = {
        'apples': [3, 2, 0, 1],
        'oranges': [0, 3, 7, 2]
    }
    purchases = pd.DataFrame(data)
    cowsay.cow(purchases)
    exit(0)
