def well(x):
    if x.count('good') == 1:
        return "Publish!"
    if x.count('good') == 2:
        return "Publish!"
    if x.count('good') > 2:
        return "I smell a series!"
    else:
        return "Fail!"