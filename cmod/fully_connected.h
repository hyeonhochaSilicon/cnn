#include "common.h"

using namespace std;

class FullyC
{
public:
	int COUNT_IN;
	int LAYER_NUM;

	FullyC(int COUNT_IN, int LAYER_NUM)
	{
		this->COUNT_IN = COUNT_IN;
		this->LAYER_NUM = LAYER_NUM;
	}

	~FullyC()
	{

	}

	void FullyConnected(float *istream, float *wstream, float *ostream);
};

void FullyC::FullyConnected(float *istream, float *wstream, float *ostream)
{
	int index = 0;

	for (int i = 0; i < this->LAYER_NUM; i++)
	{
		ostream[i] = 0;
	}

	for (int layer_num = 0; layer_num < this->LAYER_NUM; layer_num++)
	{
		for (int count = 0; count < this->COUNT_IN; count++)
		{
			ostream[index] += istream[count] * wstream[layer_num];
		}
		index++;
	}

}