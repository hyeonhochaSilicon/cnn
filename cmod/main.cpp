#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <math.h>
#include "common.h"
#include "convolution.h"
#include "pooling.h"
#include "fully_connected.h"

using namespace std;

static float* Load_Data(string filename, float* data, int size);                //Load data file
static void Activation(float *array, int SIZE);                                 //Activation
static void SoftMax(float* array, int size);                                    //SoftMax

int main(void)
{
	//create input_stream & data load
	float *istream = (float *)malloc(CONV1_INPUT_COUNT * CONV1_INPUT_DEPTH * CONV1_INPUT_ROWS * CONV1_INPUT_COLS * sizeof(float));
    istream = Load_Data("C:\\Users\\user\\Desktop\\ref_cnn_0805\\data3\\input_data.txt", istream, CONV1_INPUT_COUNT * CONV1_INPUT_DEPTH * CONV1_INPUT_ROWS * CONV1_INPUT_COLS);

	//create kernel_stream & data load
	float *wstream1 = (float *)malloc(CONV1_FILTER_COUNT * CONV1_FILTER_DEPTH * CONV1_FILTER_ROWS * CONV1_FILTER_COLS * sizeof(float));
	float *wstream2 = (float *)malloc(CONV2_FILTER_COUNT * CONV2_FILTER_DEPTH * CONV2_FILTER_ROWS * CONV2_FILTER_COLS * sizeof(float));
	wstream1 = Load_Data("C:\\Users\\user\\Desktop\\ref_cnn_0805\\data3\\weight_data.txt", wstream1, CONV1_FILTER_COUNT * CONV1_FILTER_DEPTH * CONV1_FILTER_ROWS * CONV1_FILTER_COLS);
	wstream2 = Load_Data("C:\\Users\\user\\Desktop\\ref_cnn_0805\\data3\\weight_data.txt", wstream2, CONV2_FILTER_COUNT * CONV2_FILTER_DEPTH * CONV2_FILTER_ROWS * CONV2_FILTER_COLS);

	//create bias_stream & data load
	float *bstream1 = (float *)malloc( CONV1_FILTER_COUNT * sizeof(float));
	float *bstream2 = (float *)malloc( CONV2_FILTER_COUNT * sizeof(float));
	bstream1 = Load_Data("C:\\Users\\user\Desktop\\ref_cnn_0805\\data3\\weight_data.txt", bstream1, CONV1_FILTER_COUNT);
	bstream2 = Load_Data("C:\\Users\\user\Desktop\\ref_cnn_0805\\data3\\weight_data.txt", bstream2, CONV2_FILTER_COUNT);

	//crate fully_connected & data load
	float *fc_wstream1 = (float *)malloc(FC1_KERNEL_NUM *sizeof(float));
	float *fc_wstream2 = (float *)malloc(FC2_KERNEL_NUM *sizeof(float));
	fc_wstream1 = Load_Data("C:\\Users\\user\\Desktop\\ref_cnn_0805\\data3\\weight_data.txt", fc_wstream1, FC1_KERNEL_NUM);
	fc_wstream2 = Load_Data("C:\\Users\\user\\Desktop\\ref_cnn_0805\\data3\\weight_data.txt", fc_wstream2, FC2_KERNEL_NUM);

    //create out_stream_data
	float *hconv1 = (float *)malloc(CONV1_OUTPUT_COUNT * CONV1_OUTPUT_DEPTH * CONV1_OUTPUT_ROWS * CONV1_OUTPUT_COLS * sizeof(float));
	float *pool1 = (float *)malloc(POOL1_OUTPUT_COUNT * POOL1_OUTPUT_DEPTH * POOL1_OUTPUT_ROWS * POOL1_OUTPUT_COLS * sizeof(float));
	float *hconv2 = (float *)malloc(CONV2_OUTPUT_COUNT * CONV2_OUTPUT_DEPTH * CONV2_OUTPUT_ROWS * CONV2_OUTPUT_COLS * sizeof(float));
	float *pool2 = (float *)malloc(POOL2_OUTPUT_COUNT * POOL2_OUTPUT_DEPTH * POOL2_OUTPUT_ROWS * POOL2_OUTPUT_COLS * sizeof(float));
	float *hfully1 = (float *)malloc(FC1_KERNEL_NUM * sizeof(float));
	float *hfully2 = (float *)malloc(FC2_KERNEL_NUM * sizeof(float));

	//create convoution layer
	ConvLayer *conv_layer1 = new ConvLayer(CONV1_STRIDE, CONV1_PADDING,
	                                       CONV1_FILTER_COUNT, CONV1_FILTER_DEPTH, CONV1_FILTER_ROWS, CONV1_FILTER_COLS,
										   CONV1_INPUT_COUNT, CONV1_INPUT_DEPTH, CONV1_INPUT_ROWS, CONV1_INPUT_COLS);

	ConvLayer *conv_layer2 = new ConvLayer(CONV2_STRIDE, CONV2_PADDING,
		CONV2_FILTER_COUNT, CONV2_FILTER_DEPTH, CONV2_FILTER_ROWS, CONV2_FILTER_COLS,
		CONV2_INPUT_COUNT, CONV2_INPUT_DEPTH, CONV2_INPUT_ROWS, CONV2_INPUT_COLS);

	//create pooling layer
	Pooling *pooling_layer1 = new Pooling(POOL1_STRIDE, POOL1_FILTER_ROWS, POOL1_FILTER_COLS, &(conv_layer1->out));
	Pooling *pooling_layer2 = new Pooling(POOL2_STRIDE, POOL2_FILTER_ROWS, POOL2_FILTER_COLS, &(conv_layer2->out));

	//create fully_connected layer
	FullyC *fully1 = new FullyC(FC1_KERNEL_SIZE, FC1_KERNEL_NUM);
	FullyC *fully2 = new FullyC(FC2_KERNEL_SIZE, FC2_KERNEL_NUM);
	
    

	//lenet network
	conv_layer1->Convolution(istream, wstream1, bstream1, hconv1);             //Convolution1

	pooling_layer1->MaxPooling(hconv1, pool1);                                 //pooling1

	conv_layer2->Convolution(pool1, wstream2, bstream2, hconv2);               //Convolution2

	pooling_layer2->MaxPooling(hconv2, pool2);                                 //pooling2

	fully1->FullyConnected(pool2, fc_wstream1, hfully1);                       //fully_connected1
	
	Activation(hfully1, FC1_KERNEL_NUM);                                       //ReLu

	fully2->FullyConnected(hfully1, fc_wstream2, hfully2);                     //fully_connected2

	SoftMax(hfully2, FC2_KERNEL_NUM);


	 //free
	 free(istream);

	 free(wstream1);
	 free(wstream2);

	 free(bstream1);
	 free(bstream2);

	 free(hconv1);
	 free(hconv2);

	 free(pool1);
	 free(pool2);

	 free(fc_wstream1);
	 free(fc_wstream2);

	 free(hfully1);
	 free(hfully2);

	 //delete conv_layer1;
	 //delete conv_layer2;
	 //delete pooling_layer1;
	 //delete pooling_layer2;
	 delete fully1;
	 delete fully2;
	
    return 0;
}

//Load data file
static float* Load_Data(string filename, float* data, int size) 
{
	float temp = 0.0;
	ifstream file(filename.c_str(), ios::in);
	if (file.is_open()) 
	{
		for(int i = 0; i < size; i++)
		{
			temp = 0.0;
			file >> temp;
			data[i] = temp;
		}
	}
	else 
	{
		cout << "Loading model is failed : " << filename << endl;
	}

	return data;
}

static void Activation(float *array, int SIZE)
{
	for(int i = 0; i < SIZE; i++)
	{
		if(array[i] < 0)
		{
			array[i] = 0;
		}
	}
}

static void SoftMax(float* array, int size)
{
	float m = 0;

	for (int i = 0; i < size; i++)
	{
		if (array[i] > m)
		{
			m = array[i];
		}
	}

	float sum = 0.0;
	for (int i = 0; i < size; i++)
	{
		sum += expf(array[i] - m);
	}

	float offset = m + logf(sum);
	for (int i = 0; i < size; i++)
	{
		array[i] = expf(array[i] - offset);
	}
}