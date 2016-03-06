import csv
import math 
#To open a csv file
def loader(filename):
  text=(csv.reader(open(filename,"rb")))
  lines=list(text)
  line=[]    #making a new list
  for i in range(len(lines)):
    line.append([float(x) for x in lines[i]])   # converting the elements to numbers
  return line

#To splt the data int a training set and validation set
def split(dataset,ratio):
  i=0
  train_data=[]   
  while(i<len(dataset)*ratio):
    train_data.append(dataset[i])
    i+=1
  validation_data=[]  
  while(i<len(dataset)):
    validation_data.append(dataset[i])
    i+=1
  return[train_data,validation_data]      

#To seperate the data into classes here 0 and 1 defined on the basis of the last value
def separateByClass(dataset):
	separated = {}
	for i in range(len(dataset)):
		vector = dataset[i]
		if (vector[-1] not in separated):    # if the last argument of the list is not already present in the seperated named dictionary then add it
			separated[vector[-1]] = []      #initializing the class
		separated[vector[-1]].append(vector)   # adding the vector in a class
	return separated  

def mean(numbers):
   return sum(numbers)/float(len(numbers))
def stddev(numbers):
   avg=mean(numbers)
   x=sum([pow(numbers[i]-avg,2) for i in range(len(numbers))])/(len(numbers)-1)
   return math.sqrt(x)   

# to find the standard deviation and mean of all the attributes of the given  datasets
# for dataset =[[1,20,0], [2,21,1], [3,22,0]] (no use of class here)
# output is Attribute summaries: [(2.0, 1.0), (21.0, 1.0)
def summarize(dataset): 
	summaries=[(mean(attribute),stddev(attribute)) for attribute in zip(*dataset)]  #special function to pic up the corresponding element of the vector
	del summaries[-1]  #deleting the last element which c=denotes the class
	return summaries

#it calculates the stddev and mean of all the different 
#atttributes and also calculates it for seperate classes separately


def summarize_by_class(dataset):
    separated=separateByClass(dataset)
    summaries={}
    for classValue, instances in separated.iteritems():
       summaries[classValue]=summarize(instances)
    
    return summaries   

# this fuction tells us the value of gaussian function of x for the given data using its stddev and mean

def calculateProbab(x,stddev,mean):
    exponent=math.exp(-math.pow(x-mean,2)/(2*math.pow(stddev,2)))
    return (1/(math.sqrt(2*math.pi)*stddev))*exponent

#calculate the probability of a vector to lie in the given classes seperately

def calculateClassProbabilities(summaries,vector):
    probabilities={}
    for classValue,classSummaries in summaries.iteritems():
       probabilities[classValue]=1
       for v in range(len(classSummaries)):
       	  mean,stddev =classSummaries[v] 
          probabilities[classValue]*=calculateProbab(vector[v],stddev,mean)          
    return probabilities


# to find under what class is the highest probability when we give 
# the summaries of the data we have i.e. the mean and stddev of all the attributes from the training set

def predictclass(summaries,vector):
    probabilities=calculateClassProbabilities(summaries,vector)
    prediction,value=None,0
    for classValue,probabs in probabilities.iteritems():
        if(probabs>value):
           prediction=classValue
           value=probabs
    return prediction   

# making predictions from a test set of several vectors
def predictor(summaries,testset):
   predictions=[]
   for v in range(len(testset)):
      predictions.append(predictclass(summaries,testset[v]))
   return predictions
# check the accuracy using the validation data 
def getAccuracy(testSet, predictions):
	correct = 0
	for x in range(len(testSet)):
		if testSet[x][-1] == predictions[x]:
			correct += 1
	return (correct/float(len(testSet))) * 100.0


def main():
  dataset=loader('Diabetes_Classifier_data.csv')
  training_data,validation_data=split(dataset,.67)
  summarize_t=summarize_by_class(training_data)
  predictions=predictor(summarize_t,validation_data)
  print predictions
  accuracy=getAccuracy(validation_data,predictions)
  print('Accuracy: {0}%').format(accuracy)



main()



  