def well(x):
    good_ideas = x.count('good')

    if good_ideas in (1, 2):
        return "Publish!"
    elif good_ideas > 2:
        return "I smell a series!"
    else:
        return "Fail!"