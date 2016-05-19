import numpy as np
class KNN_Classifier(object):
 	def __init__(self):
 		pass

 	def train(self,X,Y):           
 		# the train data should be (Dimention1)*(Dimention2)*(3)XN(number of images in training data)
 		self.traindata=X
 		#[3-------num_train]
 		#[3-------num_train]
 		#[3-------num_train]
 		#[3-------num_train]
 		#[3-------num_train]
 		#[class------------]
 		self.outputs=Y
 		#[class]
 		#[class]
        #[class]
        #[class]
        #[class]
 		self.valid_accuracies=[]


 	def predict(self,inputs,num_test,num_train):
 	    # input is a [(Dimention1)*(Dimention2)*(3)+1(the class)]XN(number of images in Test Set)
        Mat1=np.zeros(1,num_test)	
        for i in xrange(num_test):
         #Mat1 is a matrix that has num_test columns and 1 row 
         #[4 7 8 9 9 0 6 5 8 8 7 5 ----------num_test]
           Mat1=np.sum(np.abs(self.traindata[:-1,:]-np.tile(inputs[:,i],num_train)),axis=0)
           results=np.zeros(shape=(num_test,7))
           for k in [1, 3, 5, 10, 20, 50, 100]:
               # pick k smallest numbers
               array_indices = argsort(Mat1)[:k]
           	   dictionary=np.zeros(shape=(1,number_class))
               for m in xrange(7):
               	  dictionary[traindata[-1,array_indices[m]]=dictionary[traindata[-1,array_indices[m]]+1
               results[i,7]=np.argsort(dictionary)[-2:-1]
        #result be like this
        #[5 6 8 8 8 8 8]
        #[5 6 8 8 8 8 8]
        #[5 6 8 8 8 8 8]
        #[5 6 8 8 8 8 8]
        #till num_test
        return results

    def accuracy(self,results):
        Mat2=np.zeros_like(results)
        Mat2=results-np.tile(self.outputs,7)
        for l in xrange(7):
        	#count number of zeros in the matrix lane to store in a 1D array divide that matrix with num_test to get accuracy
        return resulting


        







