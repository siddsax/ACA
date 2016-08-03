import network
import mnist_loader
Layer_1=784
Layer_2=30
Layer_3=10
training_data, validation_data, test_data = mnist_loader.load_data_wrapper()
net = network.Network([Layer_1, Layer_2, Layer_3])
net.SGD(training_data, 30, 10, 3.0, test_data=test_data)
