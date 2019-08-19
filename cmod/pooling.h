 #include "common.h"

 using namespace std;

 class Pooling
{
public:
	SIZE filter;
	SIZE in;
    SIZE out;
    int stride;

	float ****IDATAM;
    float ****ODATAM;

    Pooling(int stride, int f_rows, int f_cols, SIZE *i_data)
    {
        this->stride = stride;

        (this->filter).rows = f_rows;
        (this->filter).cols = f_cols;

        (this->in).count = i_data->count;
        (this->in).depth = i_data->depth;
        (this->in).rows = i_data->rows;
        (this->in).cols = i_data->cols;

	    (this->out).count = i_data->count;
	    (this->out).depth = i_data->depth;
		(this->out).rows = ((i_data->rows - f_rows) / stride) + 1;
		(this->out).cols = ((i_data->cols - f_cols) / stride) + 1;

		this->IDATAM = ArrayUtils::CreateArray4D(this->IDATAM, &(this->in));
		this->ODATAM = ArrayUtils::CreateArray4D(this->ODATAM, &(this->out));

		IDATAM = ArrayUtils::InitZero(this->IDATAM, &(this->in));
		ODATAM = ArrayUtils::InitZero(this->ODATAM, &(this->out));


    }
    
    ~Pooling()
    {
		ArrayUtils::RemoveArray4D(this->IDATAM, &(this->in));
		ArrayUtils::RemoveArray4D(this->ODATAM, &(this->out));
    }

	void MaxPooling(float *istream, float *ostream);

 };

 
void Pooling::MaxPooling(float *istream, float *ostream)
{
	ArrayUtils::InputData4D(this->IDATAM, istream, &(this->in));

	float temp = 0.0;

	for (int o_count = 0; o_count < (this->out).count; o_count++)
	{
		for (int o_depth = 0; o_depth < (this->out).depth; o_depth++)
		{
			for (int row = 0; row < (this->out).rows; row++)
			{
				for (int col = 0; col < (this->out).cols; col++)
				{
					for (int i = 0; i < (this->filter).rows; i++)
					{
						for (int j = 0; j < (this->filter).cols; j++)
						{
							if (this->IDATAM[o_count][o_depth][i + (this->stride) * row][j + (this->stride) * col] > this->ODATAM[o_count][o_depth][row][col])
							{
								this->ODATAM[o_count][o_depth][row][col] = this->IDATAM[o_count][o_depth][i + (this->stride) * row][j + (this->stride) * col];
							}
						}			
					}
				}
			}
		}
	}

	ArrayUtils::Flat_4D_to_1D(this->ODATAM, ostream, &(this->out));
}