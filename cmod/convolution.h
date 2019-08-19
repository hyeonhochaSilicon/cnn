#include "common.h"

using namespace std;

/// Convolution Layer///
class ConvLayer
{
public:
    SIZE filter;
	SIZE in;
	SIZE out;

	int stride;
	int padding;                                             

	float ****IDATA;
	float ****ODATA;
	float ****KERNEL;

    void InputDataAndPadding(float *istream);
	void Convolution(float *input_stream, float *kernel_stream, float *bias_stream, float *ostream);
	

	ConvLayer(int s, int p, int fcount, int fd, int frows, int fcols, int i_count, int i_depth, int i_rows, int i_cols)
	{
		this->stride = s;
		this->padding = p;

		(this->filter).count = fcount;
		(this->filter).depth = fd;              // = i_depth
		(this->filter).rows = frows;
		(this->filter).cols = fcols;

        (this->in).count = i_count;
		(this->in).depth = i_depth;
		(this->in).rows = i_rows + 2*p;
		(this->in).cols = i_cols + 2*p;
		
		(this->out).count = i_count;
		(this->out).depth = fcount;
		(this->out).rows = ((i_rows - (this->filter).rows + 2 * this->padding) / this->stride) + 1;
		(this->out).cols = ((i_cols - (this->filter).cols + 2 * this->padding) / this->stride) + 1;

		this->IDATA = ArrayUtils::CreateArray4D(this->IDATA, &(this->in));
		this->ODATA = ArrayUtils::CreateArray4D(this->ODATA, &(this->out));
		this->KERNEL = ArrayUtils::CreateArray4D(this->KERNEL, &(this->filter));


		IDATA = ArrayUtils::InitZero(IDATA, &(this->in));
		ODATA = ArrayUtils::InitZero(ODATA, &(this->out));
	}

	~ConvLayer()
	{
		ArrayUtils::RemoveArray4D(this->IDATA, &(this->in));
		ArrayUtils::RemoveArray4D(this->ODATA, &(this->out));
		ArrayUtils::RemoveArray4D(this->KERNEL, &(this->filter));
	}
};

void ConvLayer::Convolution(float *input_stream, float *kernel_stream, float *bias_stream, float *ostream)
{

	ConvLayer::InputDataAndPadding(input_stream);
	ArrayUtils::InputData4D(this->KERNEL,kernel_stream, &filter);

    //  CONVOLUTION
	//  Precondition: INPUT[][depth][][] == KERNEL[][depth][][]
    //  
	//  INPUT[count][][][] -> OUTPUT[count][][][]                   Counts of INPUT determine counts of OUTPUT
	//  KERNEL[count][][][] -> OUTPUT[][count][][]                  Counts of KERNEL determine depths of OUTPUT

    //int g = 0;
    for(int o_count = 0; o_count < (this->out).count; o_count++)
	{
    	for (int o_depth = 0; o_depth < (this->out).depth; o_depth++)
    	{
			for(int i_depth = 0; i_depth < (this->in).depth; i_depth++)
			{
        		for (int row = 0; row < (this->out).rows; row++)
        		{
            		for (int col = 0; col < (this->out).cols; col++)
	        		{
	            		for (int i = 0; i < (this->filter).rows; i++)
	            		{
	            			for (int j = 0; j < (this->filter).cols; j++)
                    		{
                        		this->ODATA[o_count][o_depth][row][col] += this->IDATA[o_count][i_depth][i + (this->stride) * row][j + (this->stride) * col] * this->KERNEL[o_depth][i_depth][i][j];
                    		}
                		}
            		}
        		}
			}
    	}
	}

    for(int count = 0; count < (this->out).count; count++)
	{
	    for(int depth = 0; depth < (this->out).depth; depth++)
	    {
	  		for(int rows = 0; rows < (this->out).rows; rows++)
	  		{
	  			for(int cols = 0; cols < (this->out).cols; cols++)
	  			{
	 				this->ODATA[count][depth][rows][cols] += bias_stream[depth];
	  			}
	  		}
	  	}
	}


	ArrayUtils::Flat_4D_to_1D(this->ODATA, ostream, &(this->out));
}

void ConvLayer::InputDataAndPadding(float *istream)
{
	int i = 0;

	for(int count = 0; count < (this->in).count; count++)
	{
	    for(int depth = 0; depth < (this->in).depth; depth++)
        {
            for(int rows = 0; rows < (this->in).rows; rows++)
            {
                for(int cols = 0; cols < (this->in).cols; cols++)
                {
                    if( rows >= padding && rows < ((this->in).rows - this->padding) )
                    {
                        if( cols >= padding  && cols < ((this->in).cols - this->padding) )
                        {
							this->IDATA[count][depth][rows][cols] = istream[i];
							i++;
						}
					}
                }   
            }
        }
    } 
}

