from nltk.stem import WordNetLemmatizer
lemmatizer=WordNetLemmatizer()
file=open("text")
text=file.read().split()
i=0
lemmatized_text=[]
while i< len(text):
 lemmatized_text.append(lemmatizer.lemmatize(text[i],pos='v'))
 print lemmatized_text[i]+' '+text[i]
 i+=1
lemmatized_text.append(lemmatizer.lemmatize('are',pos='v'))

file.close()