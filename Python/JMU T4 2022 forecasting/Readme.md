# JMU LAST THIRD OF THE YEAR 2022 FORECAST

So, this is kind off a personal project, i also supply this information for the company JMU SELLOS MECÁNICOS\
we get the final output of the prediction on the remaining months of the year 2022 (oct, nov, dec)\
the code clearly needs improvements and i would try to keep cleaning the code. Today is 29/09/2022

Things we could get better:

1.- I would like to instead of using a groupby ( In[5]) that change the shape of my dataframe, try to find something like the sum of uniques values
so we can get the sum of values for the same month but keeping the column 'Fecha'

2.-The part that needs to be improve soon is that i look for a year and check what months are missing, i compare with shape to see which month have missing
values (In[6]) but we could try to make a ------For loop -------- where we check if there's a month missing, add it.

For example something like for dates in X          / if y-x >1 (this would check if month 4 - month 3 = 1 all good if != 1 we have a missing month)
then well here we put the code to add the missing month with 0 sales.

3.- Try to make something like a GridSearch for the parameters of the SARIMAX model

4.- Check with MSE quality of the Output of the prediction.

5.- Make some visualization for the Output of the prediction for the last third of the year.
