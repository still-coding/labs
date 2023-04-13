# with open('', 'r', encoding='1251') as f:
#     text = f.readlines()

# # print(text[:100])

# new_text = []

# for line in text:
#     new_text.append(str(line.encode()))

# # print(new_text[0])

# with open('war_and_peace-utf.txt', 'w') as f:
#     f.writelines(new_text)


import codecs

with codecs.open('ozh.txt', 'r', encoding='cp1251') as file:
    content = file.read()

with codecs.open('output.txt', 'w', encoding='utf-8') as file:
    file.write(content)
