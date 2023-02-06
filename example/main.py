"""Example Python script"""

import os

import numpy
import pandas

SECRET = os.getenv("SECRET", "No secrets set in environment variables!")


def main() -> None:
    """Main function"""

    array = numpy.array([["o", "w", "o"], ["l", "d", "!"]])
    dataframe = pandas.DataFrame(array, index=["l", "r"], columns=["H", "e", "l"])
    print(dataframe)
    print(SECRET)


if __name__ == "__main__":
    main()
