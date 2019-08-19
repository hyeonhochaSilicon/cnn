#ifndef A_H
#define A_H
// #define INPUT_COUNT 0
// #define INPUT_DEPTH 0
// #define INPUT_ROWS 0
// #define INPUT_COLS 0

#define CONV1_STRIDE 1
#define CONV1_PADDING 0
#define CONV1_INPUT_COUNT 1
#define CONV1_INPUT_DEPTH 1
#define CONV1_INPUT_ROWS 28
#define CONV1_INPUT_COLS 28
#define CONV1_FILTER_COUNT 20
#define CONV1_FILTER_DEPTH CONV1_INPUT_DEPTH                  //equal CONV_INPUT_DEPTH
#define CONV1_FILTER_ROWS 5
#define CONV1_FILTER_COLS 5
#define CONV1_OUTPUT_COUNT CONV1_INPUT_COUNT
#define CONV1_OUTPUT_DEPTH CONV1_FILTER_COUNT
#define CONV1_OUTPUT_ROWS (((CONV1_INPUT_ROWS - CONV1_FILTER_ROWS + 2*CONV1_PADDING)/CONV1_STRIDE) + 1)
#define CONV1_OUTPUT_COLS (((CONV1_INPUT_COLS - CONV1_FILTER_COLS + 2*CONV1_PADDING)/CONV1_STRIDE) + 1)

#define POOL1_STRIDE 2
#define POOL1_FILTER_ROWS 2
#define POOL1_FILTER_COLS 2
#define POOL1_OUTPUT_COUNT CONV1_OUTPUT_COUNT
#define POOL1_OUTPUT_DEPTH CONV1_OUTPUT_DEPTH
#define POOL1_OUTPUT_ROWS (((CONV1_OUTPUT_ROWS - POOL1_FILTER_ROWS)/POOL1_STRIDE) + 1)
#define POOL1_OUTPUT_COLS (((CONV1_OUTPUT_COLS - POOL1_FILTER_COLS)/POOL1_STRIDE) + 1)

#define CONV2_STRIDE 1
#define CONV2_PADDING 0
#define CONV2_INPUT_COUNT POOL1_OUTPUT_COUNT
#define CONV2_INPUT_DEPTH POOL1_OUTPUT_DEPTH
#define CONV2_INPUT_ROWS POOL1_OUTPUT_ROWS
#define CONV2_INPUT_COLS POOL1_OUTPUT_COLS
#define CONV2_FILTER_COUNT 50
#define CONV2_FILTER_DEPTH CONV2_INPUT_DEPTH                  //equal CONV_INPUT_DEPTH
#define CONV2_FILTER_ROWS 5
#define CONV2_FILTER_COLS 5
#define CONV2_OUTPUT_COUNT CONV2_INPUT_COUNT
#define CONV2_OUTPUT_DEPTH CONV2_FILTER_COUNT
#define CONV2_OUTPUT_ROWS (((CONV2_INPUT_ROWS - CONV2_FILTER_ROWS + 2*CONV2_PADDING)/CONV2_STRIDE) + 1)
#define CONV2_OUTPUT_COLS (((CONV2_INPUT_COLS - CONV2_FILTER_COLS + 2*CONV2_PADDING)/CONV2_STRIDE) + 1)

#define POOL2_STRIDE 2
#define POOL2_FILTER_ROWS 2
#define POOL2_FILTER_COLS 2
#define POOL2_OUTPUT_COUNT CONV2_OUTPUT_COUNT
#define POOL2_OUTPUT_DEPTH CONV2_OUTPUT_DEPTH
#define POOL2_OUTPUT_ROWS (((CONV2_OUTPUT_ROWS - POOL2_FILTER_ROWS)/POOL2_STRIDE) + 1)
#define POOL2_OUTPUT_COLS (((CONV2_OUTPUT_COLS - POOL2_FILTER_COLS)/POOL2_STRIDE) + 1)

#define FC1_KERNEL_SIZE (POOL2_OUTPUT_COUNT*POOL2_OUTPUT_DEPTH*POOL2_OUTPUT_ROWS*POOL2_OUTPUT_COLS)
#define FC1_KERNEL_NUM 500

#define FC2_KERNEL_SIZE FC1_KERNEL_NUM
#define FC2_KERNEL_NUM 10

typedef struct _size
{
	int count;
	int depth;
	int rows;
	int cols;
} SIZE;

class ArrayUtils
{
public:
	static float**** CreateArray4D(float ****array, SIZE *in);
	static void RemoveArray4D(float ****array, SIZE *in);
	static float**** InitZero(float**** array, SIZE *in);
	static void InputData4D(float**** array, float *stream_data, SIZE *in);
	static float* Flat_4D_to_1D(float ****array4D, float *array1D, SIZE *in);
};

float**** ArrayUtils::CreateArray4D(float ****array, SIZE *in)
{
	array = (float ****)malloc(in->count * sizeof(float ***));
	for (int a = 0; a < in->count; a++)
	{
		*(array + a) = (float ***)malloc(in->depth * sizeof(float **));
		for (int b = 0; b < in->depth; b++)
		{
			*(*(array + a) + b) = (float **)malloc(in->rows * sizeof(float *));
			for (int c = 0; c < in->rows; c++)
			{
				*(*(*(array + a) + b) + c) = (float *)malloc(in->cols * sizeof(float));
			}
		}
	}


	return array;
}

void ArrayUtils::RemoveArray4D(float ****array, SIZE *in)
{
	for (int a = 0; a < in->count; a++)
	{
		for (int b = 0; b < in->rows; b++)
		{
			for (int c = 0; c < in->cols; c++)
			{
				free(*(*(*(array + a) + b) + c));
			}
			free(*(*(array + a) + b));
		}
		free(*(array + a));
	}
}

float**** ArrayUtils::InitZero(float**** array, SIZE *in)
{
	for (int count = 0; count < in->count; count++)
	{
		for (int depth = 0; depth < in->depth; depth++)
		{
			for (int rows = 0; rows < in->rows; rows++)
			{
				for (int cols = 0; cols < in->cols; cols++)
				{
					array[count][depth][rows][cols] = 0;
				}
			}
		}
	}

	return array;
}

void ArrayUtils::InputData4D(float**** array, float *stream_data, SIZE *in)
{
	int i = 0;

	for (int count = 0; count < in->count; count++)
	{
		for (int depth = 0; depth < in->depth; depth++)
		{
			for (int rows = 0; rows < in->rows; rows++)
			{
				for (int cols = 0; cols < in->cols; cols++)
				{
					array[count][depth][rows][cols] = stream_data[i];
					i++;
				}
			}
		}
	}
}

float* ArrayUtils::Flat_4D_to_1D(float ****array4D, float *array1D, SIZE *in)
{
	int i = 0;

	for (int count = 0; count < in->count; count++)
	{
		for (int depth = 0; depth < in->depth; depth++)
		{
			for (int row = 0; row < in->rows; row++)
			{
				for (int col = 0; col < in->cols; col++)
				{
					array1D[i] = array4D[count][depth][row][col];
					i++;
				}
			}
		}
	}

	return array1D;
}
#endif